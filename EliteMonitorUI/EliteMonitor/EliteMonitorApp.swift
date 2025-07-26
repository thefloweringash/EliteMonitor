//
//  EliteMonitorApp.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import SwiftUI

@main
struct EliteMonitorApp: App {
  @NSApplicationDelegateAdaptor var delegate: EliteMonitorAppDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .environment(EliteJournal.shared)
    .modelContext(EliteJournal.shared.context)
    .commands {
      SidebarCommands()
      JournalCommands()
    }
  }
}
