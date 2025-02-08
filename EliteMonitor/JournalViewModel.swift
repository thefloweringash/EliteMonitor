//
//  JournalViewModel.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Foundation

@Observable
@MainActor
final class JournalViewModel {
  var eventIndex: Int = 0
  var events: [(Int, JournalEvent)] = []

  public func monitor() async {
    do {
      var index = 0
      for try await batch in EliteJournal.events() {
        //              events.insert((index, e), at: 0)
        print("got bundle of \(batch.count) events")
        for event in batch {
          events.append((index, event))
          index += 1
        }
        print("new index = \(index)")
      }
    } catch {
      print("Event stream failed")
    }
  }
}
