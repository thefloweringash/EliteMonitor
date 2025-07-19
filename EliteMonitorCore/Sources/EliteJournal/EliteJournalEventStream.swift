//
//  EliteJournalEventStream.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import EliteFileUtils
import EliteGameData
import Foundation
import System

public enum EliteJournalEventStream {
  private final class Handler: EliteJournalWatcherDelegate {
    let continuation: EventStream.Continuation

    init(continuation: EventStream.Continuation) {
      self.continuation = continuation
    }

    func onEventBatch(context: EventBatchContext) -> any EventBatchReceiver {
      BatchReceiver(live: context.live, continuation: continuation)
    }

    func onError(error: any Error) {
      continuation.finish(throwing: error)
    }
  }

  private struct BatchReceiver: EventBatchReceiver {
    let live: Bool
    let continuation: EventStream.Continuation

    let decoder: JSONDecoder
    var events: [JournalEvent]

    init(live: Bool, continuation: EventStream.Continuation) {
      self.live = live
      self.continuation = continuation

      decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601

      events = []
    }

    mutating func onEvent(_ data: Data) {
      do {
        let eventData = try decoder.decode(JournalEvent.self, from: data)
        events.append(eventData)
      } catch {
        fatalError()
      }
    }

    mutating func commit() {
      continuation.yield((events, live))
    }
  }

  public typealias EventBundle = ([JournalEvent], Bool)
  public typealias EventStream = AsyncThrowingStream<EventBundle, any Error>

  public static func events(containerDirectory: FilePath) -> EventStream {
    AsyncThrowingStream { continuation in
      let handler = Handler(continuation: continuation)
      let watcher = EliteJournalWatcher<Handler>(containerDirectory: containerDirectory, delegate: handler)

      continuation.onTermination = { _ in
        watcher.stopWatching()
      }

      watcher.startWatching()
    }
  }
}
