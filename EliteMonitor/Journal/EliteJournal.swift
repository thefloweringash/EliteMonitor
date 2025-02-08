//
//  EliteJournal.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Foundation

@Observable
@MainActor
final class EliteJournal {
  var eventIndex: Int = 0
  var events: [(Int, JournalEvent)] = []

  var rawMaterials: [RawMaterial: Int] = [:]
  var encodedMaterials: [EncodedMaterial: Int] = [:]
  var manufacturedMaterials: [ManufacturedMaterial: Int] = [:]

  enum Location {
    case docked(station: String, system: String)
    case undocked(system: String)
  }

  var commander: String?
  var location: Location?

  public static let shared = EliteJournal()

  public func start() {
    Task { await self.monitor() }
  }

  private func monitor() async {
    do {
      var index = 0
      for try await batch in EliteJournalWatcher.events() {
        print("got bundle of \(batch.count) events")
        for event in batch {
          handle(event)

          events.append((index, event))
          index += 1
        }
        print("new index = \(index)")
      }
    } catch {
      print("Event stream failed")
      fatalError(error.localizedDescription)
    }
  }

  private func handle(_ event: JournalEvent) {
    switch event.type {
    case "Materials":
      let details = event.details as! MaterialsDetails
      rawMaterials = details.raw
      encodedMaterials = details.encoded
      manufacturedMaterials = details.manufactured

    case "MaterialCollected":
      let details = event.details as! MaterialCollectedDetails
      switch details.category {
      case .raw:
        let name = RawMaterial(rawValue: details.name)!
        rawMaterials[name] = (rawMaterials[name] ?? 0) + 1
      case .encoded:
        let name = EncodedMaterial(rawValue: details.name)!
        encodedMaterials[name] = (encodedMaterials[name] ?? 0) + 1
      case .manufactured:
        let name = ManufacturedMaterial(rawValue: details.name)!
        manufacturedMaterials[name] = (manufacturedMaterials[name] ?? 0) + 1
      }

    case "Commander":
      let details = event.details as! CommanderDetails
      commander = details.name

    default:
      break
    }
  }
}
