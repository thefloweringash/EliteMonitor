//
//  EliteJournal.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Foundation
import Pushover

@Observable
@MainActor
final class EliteJournal {
  var events: [(Int, JournalEvent)] = []

  var rawMaterials: [RawMaterial: Int] = [:]
  var encodedMaterials: [EncodedMaterial: Int] = [:]
  var manufacturedMaterials: [ManufacturedMaterial: Int] = [:]

  enum Location {
    case docked(station: String, system: String)
    case undocked(system: String)
  }

  @ObservationIgnored
  var jumpNotifyTask: Task<Void, Never>?

  var commander: String?
  var location: Location?

  enum CarrierJumpState {
    case scheduled(at: Date, destination: BodyLocation)
    case completed(at: Date, estimatedCooldownEnd: Date)
  }

  struct BodyLocation {
    let system: String
    let body: String?
  }

  var carrierStats: CarrierStatsDetails?
  var carrierLocation: BodyLocation?
  var carrierJump: CarrierJumpState?

  struct Kill: Identifiable {
    let id: Int
    let timestamp: Date
    let delta: TimeInterval?
    let name: String
    let ship: String
    let faction: String
  }

  var kills: [Kill] = []

  public static let shared = EliteJournal()

  public func start() {
    Task { await self.monitor() }
  }

  private func monitor() async {
    do {
      var index = 0
      for try await (batch, live) in EliteJournalWatcher.events() {
        print("got bundle of \(batch.count) events")
        for event in batch {
          handle(event, live: live)

          events.append((index, event))
          index += 1
        }
        print("new index = \(index)")
      }
    } catch {
      print("Event stream failed")
      fatalError(error.localizedDescription)
    }
  }

  // Empirically determined
  let jumpCooldown: TimeInterval = 290

  private func handle(_ event: JournalEvent, live: Bool) {
    switch event.event {
    case let .materials(details):
      rawMaterials = details.raw
      encodedMaterials = details.encoded
      manufacturedMaterials = details.manufactured

    case let .materialCollected(details):
      adjustMaterialsBalance(material: details.name, quantity: 1)

    case let .missionCompleted(details):
      if let materialsReward = details.materialsReward {
        for materials in materialsReward {
          adjustMaterialsBalance(material: materials.name, quantity: materials.count)
        }
      }

    case let .materialTrade(details):
      adjustMaterialsBalance(material: details.paid.material, quantity: -details.paid.quantity)
      adjustMaterialsBalance(material: details.received.material, quantity: details.received.quantity)

    case let .commander(details):
      commander = details.name

    case let .carrierJumpRequest(details):
      let destination = BodyLocation(system: details.system, body: details.body)
      carrierJump = .scheduled(
        at: details.departureTime,
        destination: destination
      )

    case let .carrierLocation(details):
      let location = BodyLocation(system: details.system, body: nil)

      if case let .scheduled(departure, destination) = carrierJump, location.system == destination.system {
        jumpFinished(
          to: destination,
          at: event.timestamp,
          estimatedCooldownEnd: departure.advanced(by: jumpCooldown)
        )
      } else {
        carrierLocation = location
      }

    case let .carrierJump(details):
      // Empirically determined
      let estimatedCooldownEnd = if case let .scheduled(departure, _) = carrierJump {
        departure.advanced(by: jumpCooldown)
      } else {
        event.timestamp.advanced(by: jumpCooldown - 60)
      }
      jumpFinished(
        to: BodyLocation(system: details.system, body: details.body),
        at: event.timestamp,
        estimatedCooldownEnd: estimatedCooldownEnd
      )

    case let .carrierStats(details):
      carrierStats = details

    case .carrierJumpCancelled:
      carrierJump = nil

    case let .bounty(details):
      var delta: TimeInterval?
      if let lastKill = kills.last {
        delta = lastKill.timestamp.distance(to: event.timestamp)
      }
      kills.append(
        .init(
          id: kills.count,
          timestamp: event.timestamp,
          delta: delta,
          name: details.pilotName,
          ship: details.target,
          faction: details.victimFaction
        )
      )

    default:
      break
    }
  }

  private func jumpFinished(to destination: BodyLocation, at timestamp: Date, estimatedCooldownEnd: Date) {
    carrierLocation = destination
    carrierJump = .completed(
      at: timestamp,
      estimatedCooldownEnd: estimatedCooldownEnd
    )

    if estimatedCooldownEnd > Date.now {
      print("Jump cooldown ends in the future, pushing in \(Date.now.distance(to: estimatedCooldownEnd)) seconds")
      let carrierName = carrierStats.map { "\($0.name) \($0.callsign)" } ?? "Unknown Carrier"
      let message = "Carrier \(carrierName) jump to \(destination.body ?? destination.system) complete"

      jumpNotifyTask?.cancel()
      jumpNotifyTask = Task.detached {
        do {
          try await Task.sleep(for: .seconds(Date.now.distance(to: estimatedCooldownEnd)))
          await self.notifyMe(message)
        } catch {
          assert(Task.isCancelled)
        }
      }
    }
  }

  func materialBalance(material: AnyMaterial) -> Int {
    switch material {
    case let .encoded(name):
      materialBalance(material: name)
    case let .manufactured(name):
      materialBalance(material: name)
    case let .raw(name):
      materialBalance(material: name)
    }
  }

  func materialBalance(material: RawMaterial) -> Int {
    rawMaterials[material, default: 0]
  }

  func materialBalance(material: EncodedMaterial) -> Int {
    encodedMaterials[material, default: 0]
  }

  func materialBalance(material: ManufacturedMaterial) -> Int {
    manufacturedMaterials[material, default: 0]
  }

  private func adjustMaterialsBalance(material: AnyMaterial, quantity: Int) {
    switch material {
    case let .encoded(name):
      adjustMaterialsBalance(material: name, quantity: quantity)
    case let .manufactured(name):
      adjustMaterialsBalance(material: name, quantity: quantity)
    case let .raw(name):
      adjustMaterialsBalance(material: name, quantity: quantity)
    }
  }

  private func adjustMaterialsBalance(material: EncodedMaterial, quantity: Int) {
    encodedMaterials[material, default: 0] += quantity
  }

  private func adjustMaterialsBalance(material: RawMaterial, quantity: Int) {
    rawMaterials[material, default: 0] += quantity
  }

  private func adjustMaterialsBalance(material: ManufacturedMaterial, quantity: Int) {
    manufacturedMaterials[material, default: 0] += quantity
  }

  let pushover = Pushover(token: "")
  private nonisolated func notifyMe(_ message: String) async {
    let notification = Notification(message: message, to: "")
    _ = try? await pushover.send(notification)
  }
}
