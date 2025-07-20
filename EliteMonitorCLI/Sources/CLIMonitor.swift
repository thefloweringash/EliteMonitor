//
//  CLIMonitor.swift
//  EliteMonitorCLI
//
//  Created by Andrew Childs on 2025/07/21.
//

import EliteGameData
import EliteJournal
import Foundation
import Pushover

@MainActor
final class CLIMonitor {
  let name: String

  var carrierJumpMonitor = CarrierJumpMonitor()
  let pushover: Pushover?
  let pushoverUser: String?

  var carrierStats: CarrierStatsDetails?
  var carrierLocation: BodyLocation?

  var jumpNotifyTask: Task<Void, Never>?

  init(name: String, config: Config) {
    self.name = name

    if let pushoverConfig = config.pushover {
      pushover = .init(token: pushoverConfig.apiKey)
      pushoverUser = pushoverConfig.userKey
    } else {
      pushover = nil
      pushoverUser = nil
    }
  }

  func onEvent(_ event: JournalEvent, live: Bool) {
    if live {
      log("DBG: \(event.eventName)")

      switch event.event {
      case let .carrierStats(stats):
        carrierStats = stats

      case let .carrierLocation(details):
        carrierLocation = .init(system: details.system, body: nil)

      case let .carrierJumpRequest(details):
        let discordTimestamp = details.departureTime.timeIntervalSince1970.formatted(
          .number.precision(.fractionLength(0)).grouping(.never))

        log("Carrier plotted to \(details.destination.description), departing at <t:\(discordTimestamp):f> (<t:\(discordTimestamp):R>)")

        if
          let callsign = carrierStats?.callsign,
          let currentLadderPos = carrierLocation.flatMap({ BoozeCruise.ladderPosition(system: $0.system) }),
          let destinationLadderPos = BoozeCruise.ladderPosition(system: details.system)
        {
          log("/wine_carrier_departure carrier_id:\(callsign) departure_location:\(currentLadderPos) arrival_location:\(destinationLadderPos)")
        }

      case let .carrierJump(details):
        carrierLocation = BodyLocation(system: details.system, body: details.body)
        log("Carrier arrived in  \(carrierLocation!.description)")

      case .carrierJumpCancelled:
        log("Carrier jump cancelled")

      default:
        break
      }
    }

    if let jumpEvent = carrierJumpMonitor.onEvent(event) {
      switch jumpEvent {
      case let .jumpFinished(to: destination, at: timestamp, estimatedCooldownEnd: estimatedCooldownEnd):
        jumpFinished(to: destination, at: timestamp, estimatedCooldownEnd: estimatedCooldownEnd)
      @unknown default:
        break
      }
    }
  }

  func log(_ message: String) {
    print("[\(name)]: \(message)")
  }

  func onJumpCooldownFinished(destination: EliteJournal.BodyLocation, at: Date) {
    let carrierName = carrierStats.map { "\($0.name) \($0.callsign)" } ?? "Unknown Carrier"
    let message = "Carrier \(carrierName) jump to \(destination.description) complete"

    log(message)
    notify(message)
  }

  func notify(_ message: String) {
    guard let pushover, let pushoverUser else { return }
    Task {
      try? await pushover.send(message, to: pushoverUser)
    }
  }

  private func jumpFinished(
    to destination: BodyLocation,
    at timestamp: Date,
    estimatedCooldownEnd: Date,
  ) {
    if estimatedCooldownEnd > Date.now {
      jumpNotifyTask?.cancel()
      jumpNotifyTask = Task.detached {
        do {
          try await Task.sleep(for: .seconds(Date.now.distance(to: estimatedCooldownEnd)))
          await self.onJumpCooldownFinished(destination: destination, at: estimatedCooldownEnd)
        } catch {
          assert(Task.isCancelled)
        }
      }
    }
  }
}
