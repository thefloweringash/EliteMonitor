//
//  EliteJournalEventStream.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import EliteFileUtils
import EliteGameData
import Foundation
import Synchronization
import SystemPackage

public typealias EventBundle = ([JournalEvent], Bool)
public typealias EventStream = AsyncThrowingStream<EventBundle, any Error>

public final class EliteJournalEventStream: Sendable {
  // All events from only the latest journal
  public static func allEvents(containerDirectory: String) -> EventStream {
    allEvents(containerDirectory: FilePath(containerDirectory))
  }

  // All events from only the latest journal
  public static func allEvents(containerDirectory: URL) -> EventStream {
    allEvents(containerDirectory: FilePath(containerDirectory.path))
  }

  // All events from only the latest journal
  private static func allEvents(containerDirectory: FilePath) -> EventStream {
    AsyncThrowingStream { continuation in
      let handler = SingleWatcherContainerSink(continuation: continuation)
      let watcher = EliteJournalContainerWatcher(
        containerDirectory: containerDirectory,
        sink: handler
      )

      continuation.onTermination = { _ in
        watcher.stopWatching()
      }
    }
  }

  private let watcher: EliteJournalContainerWatcher<MultiWatcherContainerSink>
  private let sink: MultiWatcherContainerSink

  public convenience init(containerDirectory: String, commanders: [String]) {
    self.init(containerDirectory: FilePath(containerDirectory), commanders: commanders)
  }

  public convenience init(containerDirectory: URL, commanders: [String]) {
    self.init(containerDirectory: FilePath(containerDirectory.path), commanders: commanders)
  }

  private init(containerDirectory: FilePath, commanders: [String]) {
    sink = .init()
    watcher = .init(containerDirectory: containerDirectory, requestedCommanders: commanders, sink: sink)
  }

  public func streamForCommander(_ commander: String) -> EventStream {
    sink.streamForCommander(commander)
  }
}
