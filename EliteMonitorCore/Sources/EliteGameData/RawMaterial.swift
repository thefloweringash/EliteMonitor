//
//  RawMaterial.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import Foundation

public enum RawMaterial: String, RawRepresentable, Codable, Material, CaseIterable, Identifiable {
  public var asAnyMaterial: AnyMaterial { .raw(self) }

  public var id: Self { self }

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

  #if Localization
  public var localizedName: String {
    switch self {
    case .antimony: String(localized: "material.raw.antimony", bundle: .module)
    case .arsenic: String(localized: "material.raw.arsenic", bundle: .module)
    case .boron: String(localized: "material.raw.boron", bundle: .module)
    case .cadmium: String(localized: "material.raw.cadmium", bundle: .module)
    case .carbon: String(localized: "material.raw.carbon", bundle: .module)
    case .chromium: String(localized: "material.raw.chromium", bundle: .module)
    case .germanium: String(localized: "material.raw.germanium", bundle: .module)
    case .iron: String(localized: "material.raw.iron", bundle: .module)
    case .lead: String(localized: "material.raw.lead", bundle: .module)
    case .manganese: String(localized: "material.raw.manganese", bundle: .module)
    case .mercury: String(localized: "material.raw.mercury", bundle: .module)
    case .molybdenum: String(localized: "material.raw.molybdenum", bundle: .module)
    case .nickel: String(localized: "material.raw.nickel", bundle: .module)
    case .niobium: String(localized: "material.raw.niobium", bundle: .module)
    case .phosphorus: String(localized: "material.raw.phosphorus", bundle: .module)
    case .polonium: String(localized: "material.raw.polonium", bundle: .module)
    case .rhenium: String(localized: "material.raw.rhenium", bundle: .module)
    case .ruthenium: String(localized: "material.raw.ruthenium", bundle: .module)
    case .selenium: String(localized: "material.raw.selenium", bundle: .module)
    case .sulphur: String(localized: "material.raw.sulphur", bundle: .module)
    case .technetium: String(localized: "material.raw.technetium", bundle: .module)
    case .tellurium: String(localized: "material.raw.tellurium", bundle: .module)
    case .tin: String(localized: "material.raw.tin", bundle: .module)
    case .tungsten: String(localized: "material.raw.tungsten", bundle: .module)
    case .vanadium: String(localized: "material.raw.vanadium", bundle: .module)
    case .yttrium: String(localized: "material.raw.yttrium", bundle: .module)
    case .zinc: String(localized: "material.raw.zinc", bundle: .module)
    case .zirconium: String(localized: "material.raw.zirconium", bundle: .module)
    }
  }
  #endif

  public var grade: Int? {
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

  public var isMaxGrade: Bool? { grade.map { $0 == 4 } }

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
