//
//  ManufacturedMaterial.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import Foundation

public enum ManufacturedMaterial: String, RawRepresentable, Codable, Material, CaseIterable {
  public var asAnyMaterial: AnyMaterial { .manufactured(self) }

  case basicconductors
  case biotechconductors
  case chemicaldistillery
  case chemicalmanipulators
  case chemicalprocessors
  case chemicalstorageunits
  case compactcomposites
  case compoundshielding
  case conductiveceramics
  case conductivecomponents
  case conductivepolymers
  case configurablecomponents
  case crystalshards
  case electrochemicalarrays
  case exquisitefocuscrystals
  case fedcorecomposites
  case fedproprietarycomposites
  case filamentcomposites
  case focuscrystals
  case galvanisingalloys
  case gridresistors
  case guardian_powercell
  case guardian_powerconduit
  case guardian_sentinel_weaponparts
  case guardian_sentinel_wreckagecomponents
  case guardian_techcomponent
  case heatconductionwiring
  case heatdispersionplate
  case heatexchangers
  case heatresistantceramics
  case heatvanes
  case highdensitycomposites
  case hybridcapacitors
  case imperialshielding
  case improvisedcomponents
  case mechanicalcomponents
  case mechanicalequipment
  case mechanicalscrap
  case militarygradealloys
  case militarysupercapacitors
  case pharmaceuticalisolators
  case phasealloys
  case polymercapacitors
  case precipitatedalloys
  case protoheatradiators
  case protolightalloys
  case protoradiolicalloys
  case refinedfocuscrystals
  case salvagedalloys
  case shieldemitters
  case shieldingsensors
  case temperedalloys
  case tg_causticcrystal
  case tg_causticgeneratorparts
  case tg_causticshard
  case tg_propulsionelement
  case tg_wreckagecomponents
  case thermicalloys
  case uncutfocuscrystals
  case unknowncarapace
  case unknownenergysource
  case unknownorganiccircuitry
  case wornshieldemitters

  public var grade: Int? {
    switch self {
    case .chemicalstorageunits, .temperedalloys, .heatconductionwiring, .basicconductors, .mechanicalscrap, .gridresistors, .wornshieldemitters, .compactcomposites, .crystalshards, .salvagedalloys:
      1
    case .chemicalprocessors, .heatresistantceramics, .heatdispersionplate, .conductivecomponents, .mechanicalequipment, .hybridcapacitors, .shieldemitters, .filamentcomposites, .uncutfocuscrystals, .galvanisingalloys:
      2
    case .chemicaldistillery, .precipitatedalloys, .heatexchangers, .conductiveceramics, .mechanicalcomponents, .electrochemicalarrays, .shieldingsensors, .highdensitycomposites, .focuscrystals, .phasealloys:
      3
    case .chemicalmanipulators, .thermicalloys, .heatvanes, .conductivepolymers, .configurablecomponents, .polymercapacitors, .compoundshielding, .fedproprietarycomposites, .refinedfocuscrystals, .protolightalloys:
      4
    case .pharmaceuticalisolators, .militarygradealloys, .protoheatradiators, .biotechconductors, .improvisedcomponents, .militarysupercapacitors, .imperialshielding, .fedcorecomposites, .exquisitefocuscrystals, .protoradiolicalloys:
      5
    case .guardian_powercell, .guardian_powerconduit, .guardian_sentinel_weaponparts, .guardian_sentinel_wreckagecomponents, .guardian_techcomponent, .tg_causticcrystal, .tg_causticgeneratorparts, .tg_causticshard, .tg_propulsionelement, .tg_wreckagecomponents, .unknowncarapace, .unknownenergysource, .unknownorganiccircuitry:
      nil
    }
  }

  #if Localization
  public var localizedName: String {
    switch self {
    case .basicconductors: String(localized: "material.manufactured.basicconductors", bundle: .module)
    case .biotechconductors: String(localized: "material.manufactured.biotechconductors", bundle: .module)
    case .chemicaldistillery: String(localized: "material.manufactured.chemicaldistillery", bundle: .module)
    case .chemicalmanipulators: String(localized: "material.manufactured.chemicalmanipulators", bundle: .module)
    case .chemicalprocessors: String(localized: "material.manufactured.chemicalprocessors", bundle: .module)
    case .chemicalstorageunits: String(localized: "material.manufactured.chemicalstorageunits", bundle: .module)
    case .compactcomposites: String(localized: "material.manufactured.compactcomposites", bundle: .module)
    case .compoundshielding: String(localized: "material.manufactured.compoundshielding", bundle: .module)
    case .conductiveceramics: String(localized: "material.manufactured.conductiveceramics", bundle: .module)
    case .conductivecomponents: String(localized: "material.manufactured.conductivecomponents", bundle: .module)
    case .conductivepolymers: String(localized: "material.manufactured.conductivepolymers", bundle: .module)
    case .configurablecomponents: String(localized: "material.manufactured.configurablecomponents", bundle: .module)
    case .crystalshards: String(localized: "material.manufactured.crystalshards", bundle: .module)
    case .electrochemicalarrays: String(localized: "material.manufactured.electrochemicalarrays", bundle: .module)
    case .exquisitefocuscrystals: String(localized: "material.manufactured.exquisitefocuscrystals", bundle: .module)
    case .fedcorecomposites: String(localized: "material.manufactured.fedcorecomposites", bundle: .module)
    case .fedproprietarycomposites: String(localized: "material.manufactured.fedproprietarycomposites", bundle: .module)
    case .filamentcomposites: String(localized: "material.manufactured.filamentcomposites", bundle: .module)
    case .focuscrystals: String(localized: "material.manufactured.focuscrystals", bundle: .module)
    case .galvanisingalloys: String(localized: "material.manufactured.galvanisingalloys", bundle: .module)
    case .gridresistors: String(localized: "material.manufactured.gridresistors", bundle: .module)
    case .guardian_powercell: String(localized: "material.manufactured.guardian_powercell", bundle: .module)
    case .guardian_powerconduit: String(localized: "material.manufactured.guardian_powerconduit", bundle: .module)
    case .guardian_sentinel_weaponparts: String(localized: "material.manufactured.guardian_sentinel_weaponparts", bundle: .module)
    case .guardian_sentinel_wreckagecomponents: String(localized: "material.manufactured.guardian_sentinel_wreckagecomponents", bundle: .module)
    case .guardian_techcomponent: String(localized: "material.manufactured.guardian_techcomponent", bundle: .module)
    case .heatconductionwiring: String(localized: "material.manufactured.heatconductionwiring", bundle: .module)
    case .heatdispersionplate: String(localized: "material.manufactured.heatdispersionplate", bundle: .module)
    case .heatexchangers: String(localized: "material.manufactured.heatexchangers", bundle: .module)
    case .heatresistantceramics: String(localized: "material.manufactured.heatresistantceramics", bundle: .module)
    case .heatvanes: String(localized: "material.manufactured.heatvanes", bundle: .module)
    case .highdensitycomposites: String(localized: "material.manufactured.highdensitycomposites", bundle: .module)
    case .hybridcapacitors: String(localized: "material.manufactured.hybridcapacitors", bundle: .module)
    case .imperialshielding: String(localized: "material.manufactured.imperialshielding", bundle: .module)
    case .improvisedcomponents: String(localized: "material.manufactured.improvisedcomponents", bundle: .module)
    case .mechanicalcomponents: String(localized: "material.manufactured.mechanicalcomponents", bundle: .module)
    case .mechanicalequipment: String(localized: "material.manufactured.mechanicalequipment", bundle: .module)
    case .mechanicalscrap: String(localized: "material.manufactured.mechanicalscrap", bundle: .module)
    case .militarygradealloys: String(localized: "material.manufactured.militarygradealloys", bundle: .module)
    case .militarysupercapacitors: String(localized: "material.manufactured.militarysupercapacitors", bundle: .module)
    case .pharmaceuticalisolators: String(localized: "material.manufactured.pharmaceuticalisolators", bundle: .module)
    case .phasealloys: String(localized: "material.manufactured.phasealloys", bundle: .module)
    case .polymercapacitors: String(localized: "material.manufactured.polymercapacitors", bundle: .module)
    case .precipitatedalloys: String(localized: "material.manufactured.precipitatedalloys", bundle: .module)
    case .protoheatradiators: String(localized: "material.manufactured.protoheatradiators", bundle: .module)
    case .protolightalloys: String(localized: "material.manufactured.protolightalloys", bundle: .module)
    case .protoradiolicalloys: String(localized: "material.manufactured.protoradiolicalloys", bundle: .module)
    case .refinedfocuscrystals: String(localized: "material.manufactured.refinedfocuscrystals", bundle: .module)
    case .salvagedalloys: String(localized: "material.manufactured.salvagedalloys", bundle: .module)
    case .shieldemitters: String(localized: "material.manufactured.shieldemitters", bundle: .module)
    case .shieldingsensors: String(localized: "material.manufactured.shieldingsensors", bundle: .module)
    case .temperedalloys: String(localized: "material.manufactured.temperedalloys", bundle: .module)
    case .tg_causticcrystal: String(localized: "material.manufactured.tg_causticcrystal", bundle: .module)
    case .tg_causticgeneratorparts: String(localized: "material.manufactured.tg_causticgeneratorparts", bundle: .module)
    case .tg_causticshard: String(localized: "material.manufactured.tg_causticshard", bundle: .module)
    case .tg_propulsionelement: String(localized: "material.manufactured.tg_propulsionelement", bundle: .module)
    case .tg_wreckagecomponents: String(localized: "material.manufactured.tg_wreckagecomponents", bundle: .module)
    case .thermicalloys: String(localized: "material.manufactured.thermicalloys", bundle: .module)
    case .uncutfocuscrystals: String(localized: "material.manufactured.uncutfocuscrystals", bundle: .module)
    case .unknowncarapace: String(localized: "material.manufactured.unknowncarapace", bundle: .module)
    case .unknownenergysource: String(localized: "material.manufactured.unknownenergysource", bundle: .module)
    case .unknownorganiccircuitry: String(localized: "material.manufactured.unknownorganiccircuitry", bundle: .module)
    case .wornshieldemitters: String(localized: "material.manufactured.wornshieldemitters", bundle: .module)
    }
  }
  #endif

  var isMaxGrade: Bool? { grade.map { $0 == 5 } }
}
