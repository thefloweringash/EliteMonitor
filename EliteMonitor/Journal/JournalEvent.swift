//
//  JournalEvent.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Foundation

struct JournalEvent: Decodable, Sendable {
  let metadata: EventMetadata
  let details: (any Sendable)?

  var type: String { metadata.event }
  var timestamp: Date { metadata.timestamp }

  public init(from coder: Decoder) throws {
    metadata = try EventMetadata(from: coder)

    switch metadata.event {
      // Disabled while we think about how to represent materials, because there are materials that we don't know about.

//    case "Materials":
//      details = try MaterialsDetails(from: coder)
//
//    case "MaterialCollected":
//      details = try MaterialCollectedDetails(from: coder)

    case "Docked":
      details = try DockedDetails(from: coder)

    case "Undocked":
      details = try UndockedDetails(from: coder)

    case "Commander":
      details = try CommanderDetails(from: coder)

    case "CarrierJumpRequest":
      details = try CarrierJumpRequestDetails(from: coder)

    case "CarrierJump":
      details = try CarrierJumpDetails(from: coder)

    case "CarrierStats":
      details = try CarrierStatsDetails(from: coder)

    case "CarrierLocation":
      details = try CarrierLocationDetails(from: coder)

    case "CarrierJumpCancelled":
      fallthrough

    case "StartJump":
      fallthrough

    case "FSDJump":
      fallthrough

    case "FSDTarget":
      fallthrough

    case "LeaveBody":
      fallthrough

    case "NavRoute":
      fallthrough

    case "SupercruiseDestinationDrop":
      fallthrough

    case "SupercruiseEntry":
      fallthrough

    case "SupercruiseExit":
      fallthrough

    default:
      details = nil
    }
  }
}

struct EventMetadata: Decodable {
  let timestamp: Date
  let event: String
}

struct MaterialsDetails: Decodable {
  let raw: [RawMaterial: Int]
  let encoded: [EncodedMaterial: Int]
  let manufactured: [ManufacturedMaterial: Int]

  private enum CodingKeys: String, CodingKey {
    case raw = "Raw"
    case encoded = "Encoded"
    case manufactured = "Manufactured"
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let raw = try container.decode([MaterialCount].self, forKey: .raw)
    self.raw = Dictionary(uniqueKeysWithValues: raw.map { ($0.name, $0.count) })

    let encoded = try container.decode([LocalizedMaterialCount<EncodedMaterial>].self, forKey: .encoded)
    self.encoded = Dictionary(uniqueKeysWithValues: encoded.map { ($0.name, $0.count) })

    let manufactured = try container.decode([LocalizedMaterialCount<ManufacturedMaterial>].self, forKey: .manufactured)
    self.manufactured = Dictionary(uniqueKeysWithValues: manufactured.map { ($0.name, $0.count) })
  }
}

struct MaterialCollectedDetails: Decodable {
  enum MaterialCategory: String, RawRepresentable, Decodable {
    case raw = "Raw"
    case encoded = "Encoded"
    case manufactured = "Manufactured"
  }

  let category: MaterialCategory
  let name: String
  let count: Int

  private enum CodingKeys: String, CodingKey {
    case category = "Category"
    case name = "Name"
    case count = "Count"
  }
}

// final class StringContext {
//  private var strings: [String: Int] = [:]
//  private var inverse: [String] = []
//
//  static let materials = StringContext()
//  static let events = StringContext()
//
//  public func intern(_ string: String) -> Int {
//    if let existing = strings[string] {
//      return existing
//    } else {
//      let new = inverse.count
//      inverse.append(string)
//      strings[string] = new
//      return new
//    }
//  }
//
//  public func stringValue(_ index: Int) -> String {
//    inverse[index]
//  }
// }
//
// struct MaterialName: Decodable {
//  private let id: Int
//
//  var stringValue: String {
//    StringContext.materials.stringValue(id)
//  }
//
//  init(from decoder: any Decoder) throws {
//    let container = try decoder.singleValueContainer()
//    let stringValue = try container.decode(String.self)
//    id = StringContext.materials.intern(stringValue)
//  }
// }
//
// struct EventName: Decodable {
//  private let id: Int
//
//  var stringValue: String {
//    StringContext.events.stringValue(id)
//  }
//
//  init(from decoder: any Decoder) throws {
//    let container = try decoder.singleValueContainer()
//    let stringValue = try container.decode(String.self)
//    id = StringContext.events.intern(stringValue)
//  }
// }

struct MaterialCount: Decodable {
  let name: RawMaterial
  let count: Int

  private enum CodingKeys: String, CodingKey {
    case name = "Name"
    case count = "Count"
  }
}

struct LocalizedMaterialCount<MaterialType: Material>: Decodable {
  let name: MaterialType
  let nameLocalized: String
  let count: Int

  private enum CodingKeys: String, CodingKey {
    case name = "Name"
    case nameLocalized = "Name_Localised"
    case count = "Count"
  }
}

struct DockedDetails: Decodable {
  let stationName: String
  let starSystem: String

  private enum CodingKeys: String, CodingKey {
    case stationName = "StationName"
    case starSystem = "StarSystem"
  }
}

struct UndockedDetails: Decodable {
  let stationName: String

  private enum CodingKeys: String, CodingKey {
    case stationName = "StationName"
  }
}

struct CommanderDetails: Decodable {
  let name: String

  private enum CodingKeys: String, CodingKey {
    case name = "Name"
  }
}

// {
//  "timestamp": "2025-03-30T04:03:31Z",
//  "event": "CarrierJumpRequest",
//  "CarrierID": 3700619264,
//  "SystemName": "HD 104785",
//  "Body": "HD 104785",
//  "SystemAddress": 85063078562,
//  "BodyID": 0,
//  "DepartureTime": "2025-03-30T04:19:10Z"
// }
struct CarrierJumpRequestDetails: Decodable {
  let departureTime: Date
  let system: String
  let body: String?

  enum CodingKeys: String, CodingKey {
    case departureTime = "DepartureTime"
    case system = "SystemName"
    case body = "Body"
  }
}

struct CarrierJumpDetails: Decodable {
  let stationName: String
  let system: String
  let body: String

  enum CodingKeys: String, CodingKey {
    case stationName = "StationName"
    case system = "StarSystem"
    case body = "Body"
  }
}

struct CarrierLocationDetails: Decodable {
  let system: String

  enum CodingKeys: String, CodingKey {
    case system = "StarSystem"
  }
}

struct CarrierStatsDetails: Decodable {
  let name: String
  let callsign: String
  let fuelLevel: Int

  struct SpaceUsage: Decodable {
    let totalCapacity: Int
    let freeSpace: Int

    enum CodingKeys: String, CodingKey {
      case totalCapacity = "TotalCapacity"
      case freeSpace = "FreeSpace"
    }
  }

  let spaceUsage: SpaceUsage

  enum CodingKeys: String, CodingKey {
    case name = "Name"
    case callsign = "Callsign"
    case fuelLevel = "FuelLevel"
    case spaceUsage = "SpaceUsage"
  }
}
