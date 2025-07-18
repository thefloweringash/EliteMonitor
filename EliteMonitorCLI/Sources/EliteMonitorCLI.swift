import ArgumentParser
import EliteJournal
import Foundation

@main
struct EliteMonitorCLI: AsyncParsableCommand {
  @Argument
  var directory: String

  mutating func run() async throws {
    for try await (events, _) in EliteJournalEventStream.events(containerDirectory: directory) {
      for event in events {
        // print(String(describing: event))
        switch event.event {
        case let .materials(details):
          for (k, v) in details.raw {
            print("\(k): \(v)")
          }
        default:
          break
        }
      }
    }
  }
}
