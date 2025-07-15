//
//  ManufacturedMaterial.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import Foundation

enum ManufacturedMaterial: String, RawRepresentable, Codable, Material, CaseIterable {
  var asAnyMaterial: AnyMaterial { .manufactured(self) }

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

  var grade: Int? {
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

  var localizedName: LocalizedStringResource {
    switch self {
    case .basicconductors: "material.manufactured.basicconductors"
    case .biotechconductors: "material.manufactured.biotechconductors"
    case .chemicaldistillery: "material.manufactured.chemicaldistillery"
    case .chemicalmanipulators: "material.manufactured.chemicalmanipulators"
    case .chemicalprocessors: "material.manufactured.chemicalprocessors"
    case .chemicalstorageunits: "material.manufactured.chemicalstorageunits"
    case .compactcomposites: "material.manufactured.compactcomposites"
    case .compoundshielding: "material.manufactured.compoundshielding"
    case .conductiveceramics: "material.manufactured.conductiveceramics"
    case .conductivecomponents: "material.manufactured.conductivecomponents"
    case .conductivepolymers: "material.manufactured.conductivepolymers"
    case .configurablecomponents: "material.manufactured.configurablecomponents"
    case .crystalshards: "material.manufactured.crystalshards"
    case .electrochemicalarrays: "material.manufactured.electrochemicalarrays"
    case .exquisitefocuscrystals: "material.manufactured.exquisitefocuscrystals"
    case .fedcorecomposites: "material.manufactured.fedcorecomposites"
    case .fedproprietarycomposites: "material.manufactured.fedproprietarycomposites"
    case .filamentcomposites: "material.manufactured.filamentcomposites"
    case .focuscrystals: "material.manufactured.focuscrystals"
    case .galvanisingalloys: "material.manufactured.galvanisingalloys"
    case .gridresistors: "material.manufactured.gridresistors"
    case .guardian_powercell: "material.manufactured.guardian_powercell"
    case .guardian_powerconduit: "material.manufactured.guardian_powerconduit"
    case .guardian_sentinel_weaponparts: "material.manufactured.guardian_sentinel_weaponparts"
    case .guardian_sentinel_wreckagecomponents: "material.manufactured.guardian_sentinel_wreckagecomponents"
    case .guardian_techcomponent: "material.manufactured.guardian_techcomponent"
    case .heatconductionwiring: "material.manufactured.heatconductionwiring"
    case .heatdispersionplate: "material.manufactured.heatdispersionplate"
    case .heatexchangers: "material.manufactured.heatexchangers"
    case .heatresistantceramics: "material.manufactured.heatresistantceramics"
    case .heatvanes: "material.manufactured.heatvanes"
    case .highdensitycomposites: "material.manufactured.highdensitycomposites"
    case .hybridcapacitors: "material.manufactured.hybridcapacitors"
    case .imperialshielding: "material.manufactured.imperialshielding"
    case .improvisedcomponents: "material.manufactured.improvisedcomponents"
    case .mechanicalcomponents: "material.manufactured.mechanicalcomponents"
    case .mechanicalequipment: "material.manufactured.mechanicalequipment"
    case .mechanicalscrap: "material.manufactured.mechanicalscrap"
    case .militarygradealloys: "material.manufactured.militarygradealloys"
    case .militarysupercapacitors: "material.manufactured.militarysupercapacitors"
    case .pharmaceuticalisolators: "material.manufactured.pharmaceuticalisolators"
    case .phasealloys: "material.manufactured.phasealloys"
    case .polymercapacitors: "material.manufactured.polymercapacitors"
    case .precipitatedalloys: "material.manufactured.precipitatedalloys"
    case .protoheatradiators: "material.manufactured.protoheatradiators"
    case .protolightalloys: "material.manufactured.protolightalloys"
    case .protoradiolicalloys: "material.manufactured.protoradiolicalloys"
    case .refinedfocuscrystals: "material.manufactured.refinedfocuscrystals"
    case .salvagedalloys: "material.manufactured.salvagedalloys"
    case .shieldemitters: "material.manufactured.shieldemitters"
    case .shieldingsensors: "material.manufactured.shieldingsensors"
    case .temperedalloys: "material.manufactured.temperedalloys"
    case .tg_causticcrystal: "material.manufactured.tg_causticcrystal"
    case .tg_causticgeneratorparts: "material.manufactured.tg_causticgeneratorparts"
    case .tg_causticshard: "material.manufactured.tg_causticshard"
    case .tg_propulsionelement: "material.manufactured.tg_propulsionelement"
    case .tg_wreckagecomponents: "material.manufactured.tg_wreckagecomponents"
    case .thermicalloys: "material.manufactured.thermicalloys"
    case .uncutfocuscrystals: "material.manufactured.uncutfocuscrystals"
    case .unknowncarapace: "material.manufactured.unknowncarapace"
    case .unknownenergysource: "material.manufactured.unknownenergysource"
    case .unknownorganiccircuitry: "material.manufactured.unknownorganiccircuitry"
    case .wornshieldemitters: "material.manufactured.wornshieldemitters"
    }
  }

  var isMaxGrade: Bool? { grade.map { $0 == 5 } }
}
