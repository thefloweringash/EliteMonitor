//
//  CarrierJumpMonitor.swift
//  EliteMonitorCore
//
//  Created by Andrew Childs on 2025/07/20.
//

import EliteGameData
import Foundation

public struct CarrierJumpMonitor: Sendable {
  public enum Response {
    case jumpFinished(
      to: BodyLocation,
      at: Date,
      estimatedCooldownEnd: Date
    )
  }

  // Empirically determined
  let jumpCooldown: TimeInterval = 290

  var carrierJump: CarrierJumpState?

  public init() {}

  public mutating func onEvent(_ event: JournalEvent) -> Response? {
    switch event.event {
    case let .carrierJumpRequest(details):
      let destination = BodyLocation(system: details.system, body: details.body)
      carrierJump = .scheduled(
        at: details.departureTime,
        destination: destination
      )

    case let .carrierLocation(details):
      let location = BodyLocation(system: details.system, body: nil)

      if case let .scheduled(departure, destination) = carrierJump, location.system == destination.system {
        return .jumpFinished(
          to: destination,
          at: event.timestamp,
          estimatedCooldownEnd: departure.advanced(by: jumpCooldown)
        )
      }

    // This is an _observed_ jump, which might not be the account's carrier
    case let .carrierJump(details):
      // Empirically determined
      let estimatedCooldownEnd = if case let .scheduled(departure, _) = carrierJump {
        departure.advanced(by: jumpCooldown)
      } else {
        event.timestamp.advanced(by: jumpCooldown - 60)
      }
      return .jumpFinished(
        to: BodyLocation(system: details.system, body: details.body),
        at: event.timestamp,
        estimatedCooldownEnd: estimatedCooldownEnd
      )

    default:
      break
    }

    return nil
  }
}
