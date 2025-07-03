//
//  JournalEvent.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import Foundation

struct JournalEvent: Decodable, Sendable {
  let timestamp: Date
  let event: Event

  public init(from coder: Decoder) throws {
    let container = try coder.container(keyedBy: CodingKeys.self)
    timestamp = try container.decode(Date.self, forKey: .timestamp)

    let type = try container.decode(String.self, forKey: .type)

    switch type {
      // Disabled while we think about how to represent materials, because there are materials that we don't know about.

      //    case "Materials":
      //      details = try MaterialsDetails(from: coder)
      //
      //    case "MaterialCollected":
      //      details = try MaterialCollectedDetails(from: coder)

    case "Docked":
      event = try .docked(DockedDetails(from: coder))

    case "Undocked":
      event = try .undocked(UndockedDetails(from: coder))

    case "Commander":
      event = try .commander(CommanderDetails(from: coder))

    case "CarrierJumpRequest":
      event = try .carrierJumpRequest(CarrierJumpRequestDetails(from: coder))

    case "CarrierJump":
      event = try .carrierJump(CarrierJumpDetails(from: coder))

    case "CarrierStats":
      event = try .carrierStats(CarrierStatsDetails(from: coder))

    case "CarrierLocation":
      event = try .carrierLocation(CarrierLocationDetails(from: coder))

    case "CarrierJumpCancelled":
      event = .carrierJumpCancelled

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
      event = .unhandled(type)
    }
  }

  enum CodingKeys: String, CodingKey {
    case timestamp
    case type = "event"
  }

  enum Event {
    case materialsDetails(MaterialsDetails)
    case docked(DockedDetails)
    case undocked(UndockedDetails)
    case commander(CommanderDetails)
    case carrierJumpRequest(CarrierJumpRequestDetails)
    case carrierJump(CarrierJumpDetails)
    case carrierStats(CarrierStatsDetails)
    case carrierLocation(CarrierLocationDetails)
    case carrierJumpCancelled
    case unhandled(String)
  }
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
    let crew: Int
    let cargo: Int
    let cargoSpaceReserved: Int
    let shipPacks: Int
    let modulePacks: Int
    let freeSpace: Int

    enum CodingKeys: String, CodingKey {
      case totalCapacity = "TotalCapacity"
      case crew = "Crew"
      case cargo = "Cargo"
      case cargoSpaceReserved = "CargoSpaceReserved"
      case shipPacks = "ShipPacks"
      case modulePacks = "ModulePacks"
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
