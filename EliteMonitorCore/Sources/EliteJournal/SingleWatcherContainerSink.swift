//
//  SingleWatcherContainerSink.swift
//  EliteMonitorCore
//
//  Created by Andrew Childs on 2025/07/24.
//

import EliteFileUtils

struct SingleWatcherContainerSink: EliteJournalContainerWatcherSink {
  let continuation: EventStream.Continuation
  var watcher: EliteJournalWatcher<ContinuationSink>?

  init(continuation: EventStream.Continuation) {
    self.continuation = continuation
  }

  mutating func onJournalDetected(commanderName: String, path: String) {
    if let watcher {
      watcher.switchTo(path: path)
    } else {
      watcher = .init(
        path: path,
        sink: ContinuationSink(continuation: continuation)
      )
    }
  }

  func onError(error: any Error) {
    continuation.finish(throwing: error)
  }
}
