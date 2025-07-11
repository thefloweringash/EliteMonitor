//
//  KillsView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/07/03.
//

import SwiftUI

struct KillsView: View {
  @Environment(EliteJournal.self) var journal

  var body: some View {
    List {
      ForEach(journal.kills.reversed()) { k in
        let timestamp = Text(k.timestamp.formatted(date: .omitted, time: .shortened))
          .monospacedDigit()
        if let delta = k.delta {
//          let format = FloatingPointFormatStyle<TimeInterval>().precision(.integerLength(3...))
          let delta = Text(Measurement<UnitDuration>(value: delta, unit: .seconds)
            .formatted(.measurement(width: .narrow))).monospacedDigit()
          Text("Kill(timestamp=\(timestamp),delta=\(delta),name=\(k.name),ship=\(k.ship),faction=\(k.faction))")
        } else {
          Text("Kill(timestamp=\(timestamp),name=\(k.name),ship=\(k.ship),faction=\(k.faction))")
        }
      }
    }
  }
}
