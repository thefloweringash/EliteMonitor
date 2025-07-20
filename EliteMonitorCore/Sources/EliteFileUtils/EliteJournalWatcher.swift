//
//  EliteJournalWatcher.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Dispatch
import Foundation
import SystemPackage

import Logging

let logger = Logger(label: "nz.org.cons.EliteMonitor.EliteFileUtils")

public protocol EliteJournalWatcherSink {
  mutating func onEvents(live: Bool, next: () throws -> Data?)
  mutating func onError(error: any Error)
}

// Sendable: everything is internall synchronized via a single queue
public final class EliteJournalWatcher<Sink: EliteJournalWatcherSink>: @unchecked Sendable {
  enum Errors: Error {
    case fileOpenFailed
  }

  let queue = DispatchQueue(label: "nz.org.cons.EliteJournalWatcher")

  private var sink: Sink

  private var buffer = NewlineDelimitedSequence()

  private var journalChangeSource: (any DispatchSourceRead)?

  private var openJournal: (path: String, fd: FileDescriptor)?

  public init(path: String, sink: sending Sink) {
    self.sink = sink
    switchTo(path: path)
  }

  public func stopWatching() {
    queue.async { self._stopWatching() }
  }

  deinit {
    queue.sync { _stopWatching() }
  }

  private func _stopWatching() {
    journalChangeSource?.cancel()
    journalChangeSource = nil
  }

  public func switchTo(path: String) {
    queue.sync { _switchTo(path: path) }
  }

  private func _switchTo(path: String) {
    guard openJournal?.path != path else { return }

    self.journalChangeSource?.cancel()
    self.journalChangeSource = nil

    let fileDescriptor: FileDescriptor
    do {
      fileDescriptor = try FileDescriptor.open(FilePath(path), .readOnly)
    } catch {
      sink.onError(error: error)
      return
    }

    let journalChangeSource = DispatchSource.makeReadSource(fileDescriptor: fileDescriptor.rawValue, queue: queue)

    journalChangeSource.setRegistrationHandler(handler: .init { [weak self] in
      guard let self else { return }
      logger.debug("Starting watch of journal file: \(path)")
      openJournal = (path, fd: fileDescriptor)
      buffer.clear()
      readJournal(fileName: path, live: false)
    })

    journalChangeSource.setEventHandler(handler: .init { [weak self] in
      self?.readJournal(fileName: path, live: true)
    })

    journalChangeSource.setCancelHandler(handler: .init {
      logger.debug("Closing old journal file: \(path)")
      try? fileDescriptor.close()
    })

    self.journalChangeSource = journalChangeSource
    journalChangeSource.activate()
  }

  private func readJournal(fileName: String, live: Bool) {
    guard let openJournal, openJournal.path == fileName else { return }

    do {
      sink.onEvents(live: live) {
        try buffer.next(
          read: {
            let readBytes = try openJournal.fd.read(into: $0)
            logger.debug("readJournal: live=\(live), read \(readBytes) bytes")
            return readBytes
          })
      }
    } catch {
      sink.onError(error: error)
    }
  }
}
