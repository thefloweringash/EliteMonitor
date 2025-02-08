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
        ForEach(journal.events, id: \.0) { event in
          VStack(alignment: .leading) {
            HStack {
              Text(event.1.type)
              Spacer()
              Text(event.1.timestamp.formatted())
            }
            Text(event.1.details.debugDescription)
          }
        }
      }
      .defaultScrollAnchor(.bottom)
    }
  }
}
