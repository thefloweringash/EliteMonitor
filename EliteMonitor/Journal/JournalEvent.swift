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

    case "Materials":
      event = try .materials(MaterialsDetails(from: coder))

    case "MaterialCollected":
      event = try .materialCollected(MaterialCollectedDetails(from: coder))

    case "MissionCompleted":
      event = try .missionCompleted(MissionCompletedDetails(from: coder))

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

    case "ShipTargeted":
      event = try .shipTargeted(ShipTargetedDetails(from: coder))

    case "Bounty":
      event = try .bounty(BountyDetails(from: coder))

    case "MaterialTrade":
      event = try .materialTrade(MaterialTradeDetails(from: coder))

    case "EngineerCraft":
      event = try .engineerCraft(EngineerCraftDetails(from: coder))

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
    case materials(MaterialsDetails)
    case materialCollected(MaterialCollectedDetails)
    case missionCompleted(MissionCompletedDetails)
    case docked(DockedDetails)
    case undocked(UndockedDetails)
    case commander(CommanderDetails)
    case carrierJumpRequest(CarrierJumpRequestDetails)
    case carrierJump(CarrierJumpDetails)
    case carrierStats(CarrierStatsDetails)
    case carrierLocation(CarrierLocationDetails)
    case carrierJumpCancelled
    case shipTargeted(ShipTargetedDetails)
    case bounty(BountyDetails)
    case materialTrade(MaterialTradeDetails)
    case engineerCraft(EngineerCraftDetails)
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
  let name: AnyMaterial
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

struct ShipTargetedDetails: Decodable {
  let targetLocked: Bool
  let ship: String?
  let bounty: Int?
  let pilotRank: String?
  let faction: String?
  let legalStatus: String?

  enum CodingKeys: String, CodingKey {
    case targetLocked = "TargetLocked"
    case ship = "Ship"
    case bounty = "Bounty"
    case pilotRank = "PilotRank"
    case faction = "Faction"
    case legalStatus = "LegalStatus"
  }
}

// { "timestamp":"2025-07-03T11:58:41Z", "event":"Bounty", "Rewards":[ { "Faction":"Earls of Anana", "Reward":19600 } ], "PilotName":"$npc_name_decorate:#name=Che;", "PilotName_Localised":"Che", "Target":"sidewinder", "TotalReward":19600, "VictimFaction":"Anana Brotherhood" }
struct BountyDetails: Decodable {
  let pilotName: String
  let target: String
  let totalReward: Int
  let victimFaction: String

  enum CodingKeys: String, CodingKey {
    case pilotName = "PilotName"
    case target = "Target"
    case totalReward = "TotalReward"
    case victimFaction = "VictimFaction"
  }
}

// { "timestamp":"2025-07-09T12:18:07Z", "event":"MissionCompleted", "Faction":"HIP 90112 Jet Central Corp.", "Name":"Mission_MassacreWing_name", "LocalisedName":"Kill Anana Brotherhood faction Pirates", "MissionID":1021894599, "TargetType":"$MissionUtil_FactionTag_Pirate;", "TargetType_Localised":"Pirates", "TargetFaction":"Anana Brotherhood", "KillCount":45, "DestinationSystem":"Anana", "DestinationStation":"Yamazaki Base", "Reward":16977836, "MaterialsReward":[ { "Name":"Polonium", "Category":"$MICRORESOURCE_CATEGORY_Elements;", "Category_Localised":"Elements", "Count":12 } ], "FactionEffects":[ { "Faction":"Anana Brotherhood", "Effects":[ { "Effect":"$MISSIONUTIL_Interaction_Summary_EP_up;", "Effect_Localised":"The economic status of $#MinorFaction; has improved in the $#System; system.", "Trend":"UpGood" } ], "Influence":[ { "SystemAddress":58144730139600, "Trend":"DownBad", "Influence":"+" } ], "ReputationTrend":"DownBad", "Reputation":"+" }, { "Faction":"HIP 90112 Jet Central Corp.", "Effects":[ { "Effect":"$MISSIONUTIL_Interaction_Summary_EP_up;", "Effect_Localised":"The economic status of $#MinorFaction; has improved in the $#System; system.", "Trend":"UpGood" } ], "Influence":[ { "SystemAddress":83852497650, "Trend":"UpGood", "Influence":"++" } ], "ReputationTrend":"UpGood", "Reputation":"++" } ] }
struct MissionCompletedDetails: Decodable {
  let materialsReward: [MaterialReward]?
  let missionID: Int

  enum CodingKeys: String, CodingKey {
    case materialsReward = "MaterialsReward"
    case missionID = "MissionID"
  }

  struct MaterialReward: Decodable {
    let name: AnyMaterial
    let count: Int

    enum CodingKeys: String, CodingKey {
      case name = "Name"
      case count = "Count"
    }
  }
}

// { "timestamp":"2025-07-10T13:10:36Z", "event":"MaterialTrade", "MarketID":3230812928, "TraderType":"encoded", "Paid":{ "Material":"securityfirmware", "Material_Localised":"Security Firmware Patch", "Category":"Encoded", "Quantity":1 }, "Received":{ "Material":"industrialfirmware", "Material_Localised":"Cracked Industrial Firmware", "Category":"Encoded", "Quantity":3 } }

struct MaterialTradeDetails: Decodable {
  let paid: MaterialQuantity
  let received: MaterialQuantity

  enum CodingKeys: String, CodingKey {
    case paid = "Paid"
    case received = "Received"
  }

  struct MaterialQuantity: Decodable {
    let material: AnyMaterial
    let quantity: Int

    enum CodingKeys: String, CodingKey {
      case material = "Material"
      case quantity = "Quantity"
    }
  }
}

// { "timestamp":"2025-07-13T12:23:20Z", "event":"EngineerCraft", "Slot":"PowerPlant", "Module":"int_powerplant_size6_class5", "Ingredients":[ { "Name":"tungsten", "Count":1 }, { "Name":"compoundshielding", "Name_Localised":"Compound Shielding", "Count":1 }, { "Name":"fedcorecomposites", "Name_Localised":"Core Dynamics Composites", "Count":1 } ], "Engineer":"Hera Tani", "EngineerID":300090, "BlueprintID":128673764, "BlueprintName":"PowerPlant_Armoured", "Level":5, "Quality":0.200000, "Modifiers":[ { "Label":"Mass", "Value":24.000000, "OriginalValue":20.000000, "LessIsGood":1 }, { "Label":"Integrity", "Value":252.959991, "OriginalValue":124.000000, "LessIsGood":0 }, { "Label":"PowerCapacity", "Value":27.820801, "OriginalValue":25.200001, "LessIsGood":0 }, { "Label":"HeatEfficiency", "Value":0.358400, "OriginalValue":0.400000, "LessIsGood":1 } ] }
struct EngineerCraftDetails: Decodable {
  let ingredients: [Ingredient]

  enum CodingKeys: String, CodingKey {
    case ingredients = "Ingredients"
  }

  struct Ingredient: Decodable {
    let name: AnyMaterial
    let count: Int

    enum CodingKeys: String, CodingKey {
      case name = "Name"
      case count = "Count"
    }
  }
}
