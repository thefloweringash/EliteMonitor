//
//  CarrierView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/03/30.
//

import EliteJournal
import Foundation
import SwiftUI

struct CarrierView: View {
  @Environment(EliteJournal.self) var journal

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      if let stats = journal.carrierStats {
        HStack(alignment: .top) {
          (Text(stats.name) + Text(verbatim: " ") + Text(stats.callsign).foregroundStyle(.secondary)).font(.title)
          Spacer()
          CarrierFuelView(fuel: stats.fuelLevel)
            .contentTransition(.numericText(value: Double(stats.fuelLevel)))
            .animation(.default, value: stats.fuelLevel)
        }

        let used = Measurement<UnitMass>(value: Double(stats.spaceUsage.totalCapacity - stats.spaceUsage.freeSpace), unit: .metricTons)
          .formatted(.measurement(width: .narrow))
        let total = Measurement<UnitMass>(value: Double(stats.spaceUsage.totalCapacity), unit: .metricTons)
          .formatted(.measurement(width: .narrow))
        Text("Capacity: \(used) / \(Text(total).foregroundStyle(.secondary))")

        CarrierSpaceView(spaceUsage: stats.spaceUsage)
          .frame(height: 64)
      }

      TimelineView(.periodic(from: .init(timeIntervalSince1970: 0), by: 1)) { timeline in
        if let jump = activeJump(at: timeline.date) {
          describe(jump: jump, at: timeline.date)
        } else if let location = journal.carrierLocation {
          describe(location: location)
        }
      }

      if case let .scheduled(departure, _) = journal.carrierJump {
        var formatter = Date.FormatStyle().hour().minute().second()
        let _ = formatter.timeZone = .gmt
        Text("In Game Departure Time: \(formatter.format(departure))")

        let discordTimestamp = departure.timeIntervalSince1970.formatted(
          .number.precision(.fractionLength(0)).grouping(.never)
        )

        HStack {
          Text("Discord Absolute Timestamp:")
          Text(verbatim: "<t:\(discordTimestamp):f>")
            .textSelection(.enabled)
        }

        HStack {
          Text("Discord Relative Timestamp:")
          Text(verbatim: "<t:\(discordTimestamp):R>")
            .textSelection(.enabled)
        }
      }

      if
        let callsign = journal.carrierStats?.callsign,
        let currentLadderPos = journal.carrierLocation.flatMap({ BoozeCruise.ladderPosition(system: $0.system) }),
        let jump = journal.carrierJump,
        case let .scheduled(_, to) = jump,
        let destinationLadderPos = BoozeCruise.ladderPosition(system: to.system)
      {
        Text(verbatim: "/wine_carrier_departure carrier_id:\(callsign) departure_location:\(currentLadderPos) arrival_location:\(destinationLadderPos)")
          .textSelection(.enabled)
          .monospaced()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding(20)
  }

  func activeJump(at now: Date) -> CarrierJumpState? {
    guard let jump = journal.carrierJump else { return nil }
    switch jump {
    case let .completed(at: _, cooldownEnd) where now > cooldownEnd:
      return nil
    default:
      return jump
    }
  }

  func describe(jump: CarrierJumpState, at now: Date) -> Text {
    let style = Duration.TimeFormatStyle(pattern: .hourMinuteSecond(padHourToLength: 2))

    switch jump {
    case let .completed(at: _, cooldownEnd):
      if now < cooldownEnd {
        return Text("Arrived at \(describe(location: journal.carrierLocation!)), Cooldown ends in ") +
          Text(style.format(.seconds(now.distance(to: cooldownEnd))))
          .monospacedDigit()
      } else {
        return Text("FSD Idle")
      }
    case let .scheduled(at: jumpDate, destination):
      let from = journal.carrierLocation.map { describe(location: $0) } ?? Text(verbatim: "???")
      let to = describe(location: destination)
      return Text("Jumping \(from) \(Image(systemName: "arrowshape.right")) \(to) in ") +
        Text(style.format(.seconds(now.distance(to: jumpDate))))
        .monospacedDigit()
    }
  }

  func describe(location: BodyLocation) -> Text {
    var text = Text(location.body ?? location.system)
    if let pos = BoozeCruise.ladderPosition(system: location.system) {
      text = text + Text(verbatim: " \(pos)").foregroundStyle(.mint).bold()
    }
    return text
  }
}
