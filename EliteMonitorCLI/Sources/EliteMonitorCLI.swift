import ArgumentParser
import EliteFileUtils
import EliteGameData
import EliteJournal
import Foundation
import Logging
import Puppy
import SystemPackage

struct Config: Decodable, Sendable {
  enum Errors: Error {
    case configReadFailed(String)
    case configParseFailed(Error)
  }

  struct PushoverConfig: Decodable {
    var apiKey: String
    var userKey: String
  }

  var journalDirectory: String
  var commanders: [String]?
  var pushover: PushoverConfig?

  static func fromFile(_ path: String) throws(Errors) -> Config {
    guard let data = FileManager.default.contents(atPath: path) else {
      throw .configReadFailed(path)
    }

    let decoder = JSONDecoder()

    do {
      return try decoder.decode(Config.self, from: data)
    } catch {
      throw .configParseFailed(error)
    }
  }
}

@main
struct EliteMonitorCLI: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "em",
    subcommands: [MonitorLatest.self, Monitor.self, ParseAll.self]
  )

  struct Options: ParsableArguments {
    @Option
    var config: String

    @Flag
    var debug: Bool = false

    func apply() {
      let console = ConsoleLogger("nz.org.cons.EliteMonitorCLI")
      let puppy = Puppy(loggers: [console])

      LoggingSystem.bootstrap {
        var handler = PuppyLogHandler(label: $0, puppy: puppy)
        // Set the logging level.
        handler.logLevel = .trace
        return handler
      }
    }
  }
}

extension EliteMonitorCLI {
  struct MonitorLatest: AsyncParsableCommand {
    @OptionGroup
    var options: EliteMonitorCLI.Options

    @MainActor
    mutating func run() async throws {
      options.apply()

      let config = try Config.fromFile(options.config)

      let monitor = CLIMonitor(name: "latest", config: config)
      for try await (messages, live) in EliteJournalEventStream.allEvents(containerDirectory: config.journalDirectory) {
        for message in messages {
          monitor.onEvent(message, live: live)
        }
      }
    }
  }
}

extension EliteMonitorCLI {
  struct Monitor: AsyncParsableCommand {
    enum Errors: Error {
      case missingCommanders
    }

    @OptionGroup
    var options: EliteMonitorCLI.Options

    mutating func run() async throws {
      options.apply()

      let config = try Config.fromFile(options.config)

      guard let commanders = config.commanders else { throw Errors.missingCommanders }

      let stream = EliteJournalEventStream(containerDirectory: config.journalDirectory, commanders: commanders)

      try await withThrowingDiscardingTaskGroup { g in
        for commander in commanders {
          g.addTask { @Sendable @MainActor in
            let monitor = CLIMonitor(name: commander, config: config)
            for try await (messages, live) in stream.streamForCommander(commander) {
              for message in messages {
                monitor.onEvent(message, live: live)
              }
            }
          }
        }
      }
    }
  }
}

extension EliteMonitorCLI {
  struct ParseAll: ParsableCommand {
    @OptionGroup
    var options: EliteMonitorCLI.Options

    mutating func run() throws {
      let config = try Config.fromFile(options.config)

      let allJournals = try FileManager.default.contentsOfDirectory(atPath: config.journalDirectory)
        .filter { $0.hasPrefix("Journal.") && $0.hasSuffix(".log") }
        .sorted()
        .reversed()

      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      var sharedBuffer = NewlineDelimitedSequence()

      var eventTotals: [String: Int] = [:]
      var totalFiles = 0

      let start = ContinuousClock.now

      for j in allJournals {
        sharedBuffer.clear()

        let fh = try FileDescriptor.open(FilePath(config.journalDirectory).appending(j), .readOnly)
        defer { try? fh.close() }

        totalFiles += 1

        while let event = try sharedBuffer.next(read: { try fh.read(into: $0) }) {
          do {
            let parsed = try decoder.decode(JournalEvent.self, from: event)
            eventTotals[parsed.eventName, default: 0] += 1
          } catch {
            print("Error parsing: \(String(data: event, encoding: .utf8)!): \(error)")
          }
        }
      }

      let end = ContinuousClock.now

      print("Parsed: \(totalFiles) files in \(start.duration(to: end))")
      print("Total event count: \(eventTotals)")
    }
  }
}
