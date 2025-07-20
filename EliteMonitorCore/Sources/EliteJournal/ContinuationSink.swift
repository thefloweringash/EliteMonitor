//
//  ContinuationSink.swift
//  EliteMonitorCore
//
//  Created by Andrew Childs on 2025/07/24.
//

import EliteFileUtils
import EliteGameData
import Foundation

struct ContinuationSink: EliteJournalWatcherSink {
  let continuation: EventStream.Continuation
  let decoder: JSONDecoder

  init(continuation: EventStream.Continuation) {
    self.continuation = continuation

    decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
  }

  func onEvents(live: Bool, next: () throws -> Data?) {
    var events = [JournalEvent]()
    do {
      while let bytes = try next() {
        let event = try decoder.decode(JournalEvent.self, from: bytes)
        events.append(event)
      }
      continuation.yield((events, live))
    } catch {
      continuation.finish(throwing: error)
    }
  }

  func onError(error: any Error) {
    continuation.finish(throwing: error)
  }
}
