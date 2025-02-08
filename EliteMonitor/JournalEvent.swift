//
//  JournalEvent.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Foundation

struct JournalEvent: Sendable {
  let timestamp: Date
  let type: String

  let _raw: [String: Any]
}
