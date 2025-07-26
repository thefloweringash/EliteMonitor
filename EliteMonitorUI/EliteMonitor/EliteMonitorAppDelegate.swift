//
//  EliteMonitorAppDelegate.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import AppKit
import Logging
import Puppy

public final class EliteMonitorAppDelegate: NSObject, NSApplicationDelegate {
  public func applicationDidFinishLaunching(_ notification: Notification) {
    let puppy = Puppy(
      loggers: [OSLogger("nz.org.cons.EliteMonitor")],
    )
    LoggingSystem.bootstrap {
      var handler = PuppyLogHandler(label: $0, puppy: puppy)
      // Set the logging level.
      handler.logLevel = .trace
      return handler
    }

    // TODO: first-use onboarding
    if let url = JournalAccess.getContainerDirectory() {
      EliteJournal.shared.start(containerDirectory: url)
    }
  }
}
