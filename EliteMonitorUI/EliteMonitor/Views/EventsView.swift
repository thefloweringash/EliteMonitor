//
//  EventsView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import SwiftUI

struct EventsView: View {
  @Environment(EliteJournal.self) var journal

  var body: some View {
    VStack {
      List {
        ForEach(journal.events.reversed(), id: \.0) { _, event in

          VStack(alignment: .leading) {
            HStack {
              Text(event.timestamp.formatted())
            }
            Text(String(describing: event.event))
          }
        }
      }
    }
  }
}
