//
//  EliteJournalContainerWatcher.swift
//  EliteMonitorCore
//
//  Created by Andrew Childs on 2025/07/20.
//

import Foundation
import SystemPackage

public protocol EliteJournalContainerWatcherSink {
  mutating func onJournalDetected(commanderName: String, path: String)
  mutating func onError(error: Error)
}

// Minimal event parser to detect commander name only
struct MiniJournalEvent: Decodable {
  let timestamp: Date
  let commander: CommanderDetails?

  enum CodingKeys: String, CodingKey {
    case timestamp
    case type = "event"
  }

  struct CommanderDetails: Decodable {
    public let name: String

    private enum CodingKeys: String, CodingKey {
      case name = "Name"
    }
  }

  public init(from coder: Decoder) throws {
    let container = try coder.container(keyedBy: CodingKeys.self)
    timestamp = try container.decode(Date.self, forKey: .timestamp)
    let type = try container.decode(String.self, forKey: .type)

    if type == "Commander" {
      commander = try CommanderDetails(from: coder)
    } else {
      commander = nil
    }
  }
}

// Sendable: most things are internally synchronized via a single queue
// The only shared state is "latestJournals", which is a Mutex
public final class EliteJournalContainerWatcher<Sink: EliteJournalContainerWatcherSink>: @unchecked Sendable {
  private let containerDirectory: FilePath
  private var sink: Sink

  private var latestBookmark: String?
  private var provisionalJournals: [String: ProvisionalJournal] = [:]

  private let queue = DispatchQueue(label: "nz.org.cons.EliteJournalContainerWatcher")

  #if !os(Windows)
  private var containerChangeSource: (any DispatchSourceFileSystemObject)?
  #endif

  final class ProvisionalJournal {
    var buffer: NewlineDelimitedSequence
    let source: any DispatchSourceRead

    init(source: any DispatchSourceRead) {
      self.source = source
      buffer = .init()
    }

    deinit {
      source.cancel()
    }
  }

  public convenience init(
    containerDirectory: URL,
    requestedCommanders: [String] = [],
    sink: sending Sink
  ) {
    self.init(
      containerDirectory: FilePath(containerDirectory.path),
      requestedCommanders: requestedCommanders,
      sink: sink
    )
  }

  public convenience init(
    containerDirectory: String,
    requestedCommanders: [String] = [],
    sink: sending Sink
  ) {
    self.init(
      containerDirectory: FilePath(containerDirectory),
      requestedCommanders: requestedCommanders,
      sink: sink
    )
  }

  public init(
    containerDirectory: FilePath,
    requestedCommanders: [String] = [],
    sink: sending Sink
  ) {
    self.containerDirectory = containerDirectory
    self.sink = sink

    queue.async {
      // Search before we start monitoring
      // TODO: it's likely the most recent journal will be inspected twice
      //  once from searchForCommanders, once from being the latest file
      self._startWatching()
      self._searchForCommanders(names: requestedCommanders)
    }
  }

  func _startWatching() {
    #if !os(Windows)
    let directoryFD: FileDescriptor

    do {
      directoryFD = try FileDescriptor.open(containerDirectory, .readOnly, options: .eventOnly)
    } catch {
      sink.onError(error: error)
      return
    }

    let containerChangeSource = DispatchSource.makeFileSystemObjectSource(
      fileDescriptor: directoryFD.rawValue,
      eventMask: .write,
      queue: queue
    )

    containerChangeSource.setEventHandler(handler: .init { [weak self] in
      self?.scanDirectory()
    })

    containerChangeSource.setCancelHandler(handler: .init {
      try? directoryFD.close()
    })

    self.containerChangeSource = containerChangeSource

    containerChangeSource.activate()
    #endif

    scanDirectory()
  }

  public func stopWatching() {
    queue.async { self._stopWatching() }
  }

  func _stopWatching() {
    #if !os(Windows)
    containerChangeSource?.cancel()
    containerChangeSource = nil
    #endif
  }

  func scanDirectory() {
    logger.debug("Scanning container directory: \(self.containerDirectory.string)")

    do {
      let allJournals = try allJournals()

      if let bookmark = latestBookmark {
        let newJournals = allJournals.prefix(while: { $0 != bookmark })
        for newJournal in newJournals {
          startWatchingJournal(newJournal)
        }
        // Edge-case: if all files are deleted, this will null out the bookmark
        // Which will do the right thing.
        latestBookmark = newJournals.first
      } else if let latestJournal = allJournals.first {
        startWatchingJournal(latestJournal)
        latestBookmark = latestJournal
      }
    } catch {
      sink.onError(error: error)
    }
  }

  private func allJournals() throws -> some Collection<String> {
    try FileManager.default.contentsOfDirectory(atPath: containerDirectory.string)
      .filter { $0.hasPrefix("Journal.") && $0.hasSuffix(".log") }
      .sorted()
      .reversed()
  }

  private func _searchForCommanders(names: [String]) {
    do {
      let allJournals = try allJournals()

      var sharedBuffer = NewlineDelimitedSequence()

      var remaining = Set(names)
      for journal in allJournals {
        guard !remaining.isEmpty else { return }

        if let commander = scanFile(name: journal, sharedBuffer: &sharedBuffer) {
          guard remaining.remove(commander) != nil else {
            logger.debug("Skipping already found commander: \(commander)")
            continue
          }

          logger.debug("Found journal for specified commander: \(journal): CMDR \(commander)")
          sendJournal(commanderName: commander, fileName: journal)
        } else {
          startWatchingJournal(journal)
        }
      }
    } catch {
      sink.onError(error: error)
    }
  }

  private func scanFile(name: String, sharedBuffer: inout NewlineDelimitedSequence) -> String? {
    do {
      let fd = try FileDescriptor.open(containerDirectory.appending(name), .readOnly)
      defer { try? fd.close() }

      logger.debug("Scanning journal file: \(name)")

      sharedBuffer.clear()

      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601

      while let data = try sharedBuffer.next(read: { try fd.read(into: $0) }) {
        let event = try decoder.decode(MiniJournalEvent.self, from: data)
        if let commander = event.commander {
          logger.debug("Identified journal file: \(name): CMDR \(commander.name)")
          return commander.name
        }
      }
    } catch {
      logger.warning("Error while scanning journal: \(name): \(error), will retry")
    }
    return nil
  }

  private func startWatchingJournal(_ name: String) {
    guard provisionalJournals[name] == nil else { return }

    logger.debug("Watching provisional journal: \(name)")

    let fd: FileDescriptor
    do {
      fd = try FileDescriptor.open(containerDirectory.appending(name), .readOnly)
    } catch {
      logger.warning("Failed to open journal: \(name): \(error), ignoring file")
      return
    }

    let read = DispatchSource.makeReadSource(fileDescriptor: fd.rawValue, queue: queue)

    read.setEventHandler(handler: .init { [weak self] in
      self?.provisionalJournalChanged(name)
    })

    read.setCancelHandler(handler: .init {
      try? fd.close()
    })

    provisionalJournals[name] = .init(source: read)

    read.activate()
  }

  private func provisionalJournalChanged(_ name: String) {
    guard let journal = provisionalJournals[name] else {
      logger.debug("Spurious change for untracked file: \(name)")
      return
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    do {
      let fd = FileDescriptor(rawValue: CInt(journal.source.handle))
      while let data = try journal.buffer.next(read: { try fd.read(into: $0) }) {
        let event = try decoder.decode(MiniJournalEvent.self, from: data)
        if let commander = event.commander {
          logger.debug("Identified journal file: \(name): CMDR \(commander.name)")
          sendJournal(commanderName: commander.name, fileName: name)

          return
        }
      }
    } catch {
      logger.warning("Error reading from journal: \(name): \(error), ignoring file")
      provisionalJournals[name] = nil
    }
  }

  private func sendJournal(commanderName: String, fileName: String) {
    provisionalJournals[fileName] = nil
    sink.onJournalDetected(commanderName: commanderName, path: containerDirectory.appending(fileName).string)
  }
}
