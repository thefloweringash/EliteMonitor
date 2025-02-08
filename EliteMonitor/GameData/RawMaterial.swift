//
//  RawMaterial.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import Foundation

enum RawMaterial: String, RawRepresentable, Decodable, Material {
  case antimony
  case arsenic
  case boron
  case cadmium
  case carbon
  case chromium
  case germanium
  case iron
  case lead
  case manganese
  case mercury
  case molybdenum
  case nickel
  case niobium
  case phosphorus
  case polonium
  case rhenium
  case ruthenium
  case selenium
  case sulphur
  case technetium
  case tellurium
  case tin
  case tungsten
  case vanadium
  case yttrium
  case zinc
  case zirconium

  var localizedName: LocalizedStringResource {
    switch self {
    case .antimony: "material.raw.antimony"
    case .arsenic: "material.raw.arsenic"
    case .boron: "material.raw.boron"
    case .cadmium: "material.raw.cadmium"
    case .carbon: "material.raw.carbon"
    case .chromium: "material.raw.chromium"
    case .germanium: "material.raw.germanium"
    case .iron: "material.raw.iron"
    case .lead: "material.raw.lead"
    case .manganese: "material.raw.manganese"
    case .mercury: "material.raw.mercury"
    case .molybdenum: "material.raw.molybdenum"
    case .nickel: "material.raw.nickel"
    case .niobium: "material.raw.niobium"
    case .phosphorus: "material.raw.phosphorus"
    case .polonium: "material.raw.polonium"
    case .rhenium: "material.raw.rhenium"
    case .ruthenium: "material.raw.ruthenium"
    case .selenium: "material.raw.selenium"
    case .sulphur: "material.raw.sulphur"
    case .technetium: "material.raw.technetium"
    case .tellurium: "material.raw.tellurium"
    case .tin: "material.raw.tin"
    case .tungsten: "material.raw.tungsten"
    case .vanadium: "material.raw.vanadium"
    case .yttrium: "material.raw.yttrium"
    case .zinc: "material.raw.zinc"
    case .zirconium: "material.raw.zirconium"
    }
  }

  var grade: Int? {
    switch self {
    case .carbon, .phosphorus, .sulphur, .iron, .nickel, .rhenium, .lead:
      1
    case .vanadium, .chromium, .manganese, .zinc, .germanium, .arsenic, .zirconium:
      2
    case .niobium, .molybdenum, .cadmium, .tin, .tungsten, .mercury, .boron:
      3
    case .yttrium, .technetium, .ruthenium, .selenium, .tellurium, .polonium, .antimony:
      4
    }
  }

//  var category: Int {
//    switch self {
//    case .carbon, .vanadium, .niobium, .yttrium: 1
//    case .phosphorus, .chromium, .molybdenum, .technetium: 2
//    case .sulphur, .manganese, .cadmium, .ruthenium: 3
//    case .iron, .zinc, .tin, .selenium: 4
//    case .nickel, .germanium, .tungsten, .tellurium: 5
//    case .rhenium, .arsenic, .mercury, .polonium: 6
//    case .lead, .zirconium, .boron, .antimony: 7
//    }
//  }
}
