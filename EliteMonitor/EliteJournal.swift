//
//  EliteJournal.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Foundation
import Dispatch
import System

final class EliteJournal {
  typealias EventStream = AsyncThrowingStream<[JournalEvent], any Error>

  enum Errors: Error {
    case fileOpenFailed
  }

  static var containerDirectory: FilePath {
    "/Applications/Steam-vk.app/Contents/SharedSupport/prefix/drive_c/users/Kegworks/Saved Games/Frontier Developments/Elite Dangerous"
  }

  private static let shared = EliteJournal()

  private static let queue = DispatchQueue(label: "nz.org.cons.elite-journal-events")

  private var continuation: EventStream.Continuation?

  private let buffer = NDJSONBuffer()

  private var containerChangeSource: (any DispatchSourceFileSystemObject)?
  private var journalChangeSource: (any DispatchSourceRead)?

  private var openJournal: (String, FileDescriptor)?

  private func events() -> EventStream {
    AsyncThrowingStream { continuation in
      continuation.onTermination = { _term in
        Self.queue.async {
          self.stopWatching()
        }
      }
      Self.queue.async {
        self.startWatching(continuation: continuation)
      }
    }
  }

  private func startWatching(continuation: EventStream.Continuation?) {
    self.continuation = continuation

    let directoryFD: FileDescriptor

    do {
      directoryFD = try FileDescriptor.open(Self.containerDirectory, .readOnly, options: .eventOnly)
    } catch {
      terminate(throwing: error)
      return
    }

    let containerChangeSource = DispatchSource.makeFileSystemObjectSource(
      fileDescriptor: directoryFD.rawValue,
      eventMask: .write,
      queue: Self.queue
    )

    containerChangeSource.setEventHandler(handler: .init { [weak self] in
      self?.watchLatestJournal()
    })

    containerChangeSource.setCancelHandler(handler: .init {
      try? directoryFD.close()
    })

    self.containerChangeSource = containerChangeSource

    containerChangeSource.activate()

    watchLatestJournal()
  }

  private func stopWatching() {
    // We only stop because something interrupted the AsyncSequence.
    // No need to also terminate that sequence.
    continuation = nil

    containerChangeSource?.cancel()
    containerChangeSource = nil

    journalChangeSource?.cancel()
    journalChangeSource = nil

    openJournal = nil
  }

  private func watchLatestJournal() {
    let fileFD: FileDescriptor
    let path: String

    do {
      guard let latestJournal =
        try FileManager.default.contentsOfDirectory(atPath: Self.containerDirectory.string)
          .filter({ $0.hasPrefix("Journal.") && $0.hasSuffix(".log") })
          .sorted()
          .last
      else {
        print("No journal found, waiting for first journal")
        return
      }

      if let openJournal, openJournal.0 == latestJournal {
        print("Latest journal already open, no-op")
        return
      }

      fileFD = try FileDescriptor.open(Self.containerDirectory.appending(latestJournal), .readOnly, options: .nonBlocking)
      path = latestJournal
    } catch {
      terminate(throwing: error)
      return
    }

    let journalChangeSource = DispatchSource.makeReadSource(fileDescriptor: fileFD.rawValue, queue: Self.queue)

    journalChangeSource.setEventHandler(handler: .init { [weak self] in
      self?.readJournal(fileName: path)
    })

    journalChangeSource.setCancelHandler(handler: .init {
      try? fileFD.close()
    })

    self.openJournal = (path, fileFD)
    self.journalChangeSource = journalChangeSource
    self.buffer.clear()

    journalChangeSource.activate()

    self.readJournal(fileName: path)
  }

  private func terminate(throwing error: any Error) {
    continuation!.finish(throwing: error)
    continuation = nil

    containerChangeSource = nil
    journalChangeSource = nil
  }

  private func readJournal(fileName: String) {
    guard let openJournal, openJournal.0 == fileName, let continuation else { return }
    do {
      var events: [JournalEvent] = []
      try buffer.fill {
        try openJournal.1.read(into: $0)
      } onChunk: { data in
        let json = (try! JSONSerialization.jsonObject(with: data)) as! [String: Any]
        let timestamp = ISO8601DateFormatter().date(from: json["timestamp"] as! String)!
        let event = json["event"] as! String

        events.append(JournalEvent(timestamp: timestamp, type: event, _raw: json))
      }
      continuation.yield(events)
    } catch {
      terminate(throwing: error)
    }
  }

  public static func events() -> EventStream {
    return shared.events()
  }
}
