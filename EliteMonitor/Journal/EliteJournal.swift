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

  private func handle(_ event: JournalEvent, live: Bool) {
    switch event.type {
//    case "Materials":
//      let details = event.details as! MaterialsDetails
//      rawMaterials = details.raw
//      encodedMaterials = details.encoded
//      manufacturedMaterials = details.manufactured
//
//    case "MaterialCollected":
//      let details = event.details as! MaterialCollectedDetails
//      switch details.category {
//      case .raw:
//        let name = RawMaterial(rawValue: details.name)!
//        rawMaterials[name] = (rawMaterials[name] ?? 0) + 1
//      case .encoded:
//        let name = EncodedMaterial(rawValue: details.name)!
//        encodedMaterials[name] = (encodedMaterials[name] ?? 0) + 1
//      case .manufactured:
//        let name = ManufacturedMaterial(rawValue: details.name)!
//        manufacturedMaterials[name] = (manufacturedMaterials[name] ?? 0) + 1
//      }

    case "Commander":
      let details = event.details as! CommanderDetails
      commander = details.name

    case "CarrierJumpRequest":
      let details = event.details as! CarrierJumpRequestDetails
      let destination = BodyLocation(system: details.system, body: details.body)
      carrierJump = .scheduled(
        at: details.departureTime,
        destination: destination
      )

    case "CarrierLocation":
      let details = event.details as! CarrierLocationDetails
      carrierLocation = .init(system: details.system, body: nil)

    case "CarrierJump":
      // 5 minutes ought to be enough, right?
      let cooldown: TimeInterval = 300
      let estimatedCooldownEnd = if case let .scheduled(departure, _) = carrierJump {
        departure.advanced(by: cooldown)
      } else {
        event.timestamp.advanced(by: cooldown - 60)
      }
      let details = event.details as! CarrierJumpDetails
      carrierJump = .completed(
        at: event.timestamp,
        estimatedCooldownEnd: estimatedCooldownEnd
      )
      carrierLocation = BodyLocation(system: details.system, body: details.body)
      if estimatedCooldownEnd > Date.now {
        print("Jump cooldown ends in the future, pushing in \(Date.now.distance(to: estimatedCooldownEnd)) seconds")
        let carrierName = carrierStats.map { "\($0.name) \($0.callsign)" } ?? details.stationName
        let message = "Carrier \(carrierName) jump to \(details.body) complete"

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

    case "CarrierStats":
      carrierStats = (event.details as! CarrierStatsDetails)

    default:
      break
    }
  }

  let pushover = Pushover(token: "")
  private nonisolated func notifyMe(_ message: String) async {
    let notification = Notification(message: message, to: "")
    _ = try? await pushover.send(notification)
  }
}
