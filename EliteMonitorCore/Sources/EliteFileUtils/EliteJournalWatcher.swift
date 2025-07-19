//
//  EliteJournalWatcher.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Dispatch
import Foundation
import SystemPackage

#if canImport(OSLog)
import OSLog
#endif

public struct EventBatchContext {
  public let live: Bool
}

public protocol EventBatchReceiver: Sendable {
  mutating func onEvent(_: Data)
  mutating func commit()
}

public protocol EliteJournalWatcherDelegate: AnyObject {
  func onEventBatch(context: EventBatchContext) -> EventBatchReceiver
  func onError(error: any Error)
}

private let queue = DispatchQueue(label: "nz.org.cons.elite-journal-events")

public final class EliteJournalWatcher<Delegate: EliteJournalWatcherDelegate>: @unchecked Sendable {
  #if canImport(OSLog)
  let logger = Logger(subsystem: "nz.org.cons.EliteMonitor", category: "EliteJournalWatcher")
  #endif

  enum Errors: Error {
    case fileOpenFailed
  }

  private let containerDirectory: FilePath

  private let delegate: EliteJournalWatcherDelegate

  private let buffer = NDJSONBuffer()

  #if !os(Windows)
  private var containerChangeSource: (any DispatchSourceFileSystemObject)?
  #endif
  private var journalChangeSource: (any DispatchSourceRead)?

  private var openJournal: (path: String, fd: FileDescriptor)?

  public init(containerDirectory: FilePath, delegate: EliteJournalWatcherDelegate) {
    self.containerDirectory = containerDirectory
    self.delegate = delegate
  }

  public func startWatching() {
    queue.async { self._startWatching() }
  }

  private func _startWatching() {
    #if !os(Windows)
    let directoryFD: FileDescriptor

    do {
      directoryFD = try FileDescriptor.open(containerDirectory, .readOnly, options: .eventOnly)
    } catch {
      delegate.onError(error: error)
      return
    }

    let containerChangeSource = DispatchSource.makeFileSystemObjectSource(
      fileDescriptor: directoryFD.rawValue,
      eventMask: .write,
      queue: queue
    )

    containerChangeSource.setEventHandler(handler: .init { [weak self] in
      self?.watchLatestJournal()
    })

    containerChangeSource.setCancelHandler(handler: .init {
      try? directoryFD.close()
    })

    self.containerChangeSource = containerChangeSource

    containerChangeSource.activate()
    #endif

    watchLatestJournal()
  }

  public func stopWatching() {
    queue.async { self._stopWatching() }
  }

  private func _stopWatching() {
    #if !os(Windows)
    containerChangeSource?.cancel()
    containerChangeSource = nil
    #endif

    journalChangeSource?.cancel()
    journalChangeSource = nil

    openJournal = nil
  }

  private func watchLatestJournal() {
    let fileFD: FileDescriptor
    let path: String

    #if canImport(OSLog)
    logger.debug("Directory changed, looking for new journal file")
    #endif

    do {
      guard let latestJournal =
        try FileManager.default.contentsOfDirectory(atPath: containerDirectory.string)
          .filter({ $0.hasPrefix("Journal.") && $0.hasSuffix(".log") })
          .sorted()
          .last
      else {
        #if canImport(OSLog)
        logger.debug("No journal found, waiting for first journal")
        #endif
        return
      }

      if let openJournal, openJournal.path == latestJournal {
        #if canImport(OSLog)
        logger.debug("Latest journal already open, no-op")
        #endif
        return
      }

      fileFD = try FileDescriptor.open(containerDirectory.appending(latestJournal), .readOnly)
      path = latestJournal
    } catch {
      delegate.onError(error: error)
      return
    }

    self.journalChangeSource?.cancel()
    self.journalChangeSource = nil

    let journalChangeSource = DispatchSource.makeReadSource(fileDescriptor: fileFD.rawValue, queue: queue)

    journalChangeSource.setEventHandler(handler: .init { [weak self] in
      self?.readJournal(fileName: path, live: true)
    })

    journalChangeSource.setCancelHandler(handler: .init {
      try? fileFD.close()
    })

    openJournal = (path, fileFD)
    self.journalChangeSource = journalChangeSource
    buffer.clear()

    journalChangeSource.activate()

    readJournal(fileName: path, live: false)
  }

  private func readJournal(fileName: String, live: Bool) {
    guard let openJournal, openJournal.0 == fileName else { return }
    do {
      var batch = delegate.onEventBatch(context: .init(live: live))
      try buffer.fill {
        try openJournal.fd.read(into: $0)
      } onChunk: { data in
        batch.onEvent(data)
      }
      batch.commit()
    } catch {
      delegate.onError(error: error)
    }
  }
}
