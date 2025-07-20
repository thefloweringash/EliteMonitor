//
//  MultiWatcherContainerSink.swift
//  EliteMonitorCore
//
//  Created by Andrew Childs on 2025/07/24.
//

import EliteFileUtils
import Synchronization

/// A meeting place for directory scans and streams
final class MultiWatcherContainerSink: EliteJournalContainerWatcherSink, Sendable {
  private let bindings = Mutex<(bindings: [String: CommanderBinding], nextId: Int)>(([:], 0))

  private class CommanderBinding {
    private var path: String?
    private var continuations: [(Int, EventStream.Continuation)] = []
    private var watchers: [(Int, EliteJournalWatcher<ContinuationSink>)] = []

    init(path: String) {
      self.path = path
    }

    init(continuation: EventStream.Continuation, id: Int) {
      continuations = [(id, continuation)]
    }

    func onJournalChange(path: String) {
      self.path = path
      for (_, watcher) in watchers {
        watcher.switchTo(path: path)
      }
      for (id, continuation) in continuations {
        watchers.append((id, .init(path: path, sink: .init(continuation: continuation))))
      }
      continuations.removeAll()
    }

    func onContinuation(_ continuation: EventStream.Continuation, id: Int) {
      if let path {
        watchers.append((id, .init(path: path, sink: .init(continuation: continuation))))
      } else {
        continuations.append((id, continuation))
      }
    }

    func remove(id: Int) {
      if let id = watchers.firstIndex(where: { $0.0 == id }) {
        let (_, watcher) = watchers.remove(at: id)
        watcher.stopWatching()
      }
    }
  }

  func streamForCommander(_ commanderName: String) -> EventStream {
    AsyncThrowingStream { continuation in
      bindings.withLock { state in
        let id = state.nextId
        state.nextId += 1

        continuation.onTermination = { _ in
          self.removeWatcher(commanderName: commanderName, id: id)
        }

        if let existing = state.bindings[commanderName] {
          existing.onContinuation(continuation, id: id)
        } else {
          state.bindings[commanderName] = .init(continuation: continuation, id: id)
        }
      }
    }
  }

  func removeWatcher(commanderName: String, id: Int) {
    bindings.withLock { state in
      state.bindings[commanderName]?.remove(id: id)
    }
  }

  func onJournalDetected(commanderName: String, path: String) {
    bindings.withLock { state in
      if let existing = state.bindings[commanderName] {
        existing.onJournalChange(path: path)
      } else {
        state.bindings[commanderName] = .init(path: path)
      }
    }
  }

  func onError(error: any Error) {
    // ???
    fatalError()
  }
}
