//
//  ContentView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import SwiftUI

struct ContentView: View {
  @Environment(EliteJournal.self) var journal

  enum SelectedTab {
    case materials
    case events
  }

  @State var selectedTab: SelectedTab = .materials

  var body: some View {
    NavigationSplitView {
      List(selection: $selectedTab) {
        Text("Materials").tag(SelectedTab.materials)
        Text("Events").tag(SelectedTab.events)
      }
    } detail: {
      switch selectedTab {
      case .materials:
        MaterialsView()
      case .events:
        EventsView()
      }
    }
    .navigationTitle(journal.commander.map { "CMDR \($0)" } ?? "CMDR Jameson")
  }
}

#Preview {
  ContentView()
}
