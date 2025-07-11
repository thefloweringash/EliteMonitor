//
//  CarrierView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/03/30.
//

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
      }

      if
        let callsign = journal.carrierStats?.callsign,
        let currentLadderPos = journal.carrierLocation.flatMap({ ladderPosition(system: $0.system) }),
        let jump = journal.carrierJump,
        case let .scheduled(_, to) = jump,
        let destinationLadderPos = ladderPosition(system: to.system)
      {
        Text(verbatim: "/wine_carrier_departure carrier_id:\(callsign) departure_location:\(currentLadderPos) arrival_location:\(destinationLadderPos)")
          .textSelection(.enabled)
          .monospaced()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding(20)
  }

  func activeJump(at now: Date) -> EliteJournal.CarrierJumpState? {
    guard let jump = journal.carrierJump else { return nil }
    switch jump {
    case let .completed(at: _, cooldownEnd) where now > cooldownEnd:
      return nil
    default:
      return jump
    }
  }

  func describe(jump: EliteJournal.CarrierJumpState, at now: Date) -> Text {
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

  //  N-0: HIP 58832 (Rackham’s Peak)
  //  N-1: HD 105341 (Carrier Bottleneck System)
  //  N-2: HD 104495 (Carrier Parking System)
  //  N-3: HIP 57784
  //  N-4: HIP 57478
  //  N-5: HIP 56843
  //  N-6: HD 104392
  //  N-7: HD 102779
  //  N-8: HD 102000
  //  N-9: HD 104785
  //  N10: HD 105548
  //  N11: HD 107865
  //  N12: Plaa Trua WQ-C d13-0
  //  N13: Plaa Trua QL-B c27-0
  //  N14: Wregoe OP-D b58-0
  //  N15: Wregoe ZE-B c28-2
  //  N16: Gali (Chadwick Dock)
  static let ladder: [String] = [
    "HIP 58832",
    "HD 105341",
    "HD 104495",
    "HIP 57784",
    "HIP 57478",
    "HIP 56843",
    "HD 104392",
    "HD 102779",
    "HD 102000",
    "HD 104785",
    "HD 105548",
    "HD 107865",
    "Plaa Trua WQ-C d13-0",
    "Plaa Trua QL-B c27-0",
    "Wregoe OP-D b58-0",
    "Wregoe ZE-B c28-2",
    "Gali",
  ]

  func ladderPosition(system: String) -> String? {
    Self.ladder.firstIndex(of: system).map { "N\($0)" }
  }

  func describe(location: EliteJournal.BodyLocation) -> Text {
    var text = Text(location.body ?? location.system)
    if let pos = ladderPosition(system: location.system) {
      text = text + Text(verbatim: " \(pos)").foregroundStyle(.mint).bold()
    }
    return text
  }
}
