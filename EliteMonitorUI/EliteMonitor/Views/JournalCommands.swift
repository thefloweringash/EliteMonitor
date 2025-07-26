//
//  JournalCommands.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/07/26.
//

import SwiftUI

struct JournalCommands: Commands {
  @State var showOpenFile: Bool = false

  var body: some Commands {
    CommandGroup(after: .newItem) {
      Button("Open Journal Directory") {
        showOpenFile = true
      }
      .keyboardShortcut("O")
      .fileImporter(isPresented: $showOpenFile, allowedContentTypes: [.directory]) { result in
        if case let .success(directory) = result {
          EliteJournal.shared.start(containerDirectory: directory)
          JournalAccess.saveContainerDirectory(directory)
        }
      }
    }
  }
}
