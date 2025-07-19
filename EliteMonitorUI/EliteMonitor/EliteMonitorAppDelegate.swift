//
//  EliteMonitorAppDelegate.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import AppKit

public final class EliteMonitorAppDelegate: NSObject, NSApplicationDelegate {
  public func applicationDidFinishLaunching(_ notification: Notification) {
    EliteJournal.shared.start()
  }
}
