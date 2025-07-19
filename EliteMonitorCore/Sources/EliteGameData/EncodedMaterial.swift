//
//  EncodedMaterial.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import Foundation

public enum EncodedMaterial: String, RawRepresentable, Codable, Material, CaseIterable {
  public var asAnyMaterial: AnyMaterial { .encoded(self) }

  case adaptiveencryptors
  case ancientbiologicaldata
  case ancientculturaldata
  case ancienthistoricaldata
  case ancientlanguagedata
  case ancienttechnologicaldata
  case archivedemissiondata
  case bulkscandata
  case classifiedscandata
  case compactemissionsdata
  case consumerfirmware
  case dataminedwake
  case decodedemissiondata
  case disruptedwakeechoes
  case embeddedfirmware
  case emissiondata
  case encodedscandata
  case encryptedfiles
  case encryptionarchives
  case encryptioncodes
  case fsdtelemetry
  case guardian_moduleblueprint
  case hyperspacetrajectories
  case industrialfirmware
  case legacyfirmware
  case scanarchives
  case scandatabanks
  case scrambledemissiondata
  case securityfirmware
  case shieldcyclerecordings
  case shielddensityreports
  case shieldfrequencydata
  case shieldpatternanalysis
  case shieldsoakanalysis
  case symmetrickeys
  case wakesolutions

  #if Localization
  public var localizedName: String {
    switch self {
    case .adaptiveencryptors: String(localized: "material.encoded.adaptiveencryptors", bundle: .module)
    case .ancientbiologicaldata: String(localized: "material.encoded.ancientbiologicaldata", bundle: .module)
    case .ancientculturaldata: String(localized: "material.encoded.ancientculturaldata", bundle: .module)
    case .ancienthistoricaldata: String(localized: "material.encoded.ancienthistoricaldata", bundle: .module)
    case .ancientlanguagedata: String(localized: "material.encoded.ancientlanguagedata", bundle: .module)
    case .ancienttechnologicaldata: String(localized: "material.encoded.ancienttechnologicaldata", bundle: .module)
    case .archivedemissiondata: String(localized: "material.encoded.archivedemissiondata", bundle: .module)
    case .bulkscandata: String(localized: "material.encoded.bulkscandata", bundle: .module)
    case .classifiedscandata: String(localized: "material.encoded.classifiedscandata", bundle: .module)
    case .compactemissionsdata: String(localized: "material.encoded.compactemissionsdata", bundle: .module)
    case .consumerfirmware: String(localized: "material.encoded.consumerfirmware", bundle: .module)
    case .dataminedwake: String(localized: "material.encoded.dataminedwake", bundle: .module)
    case .decodedemissiondata: String(localized: "material.encoded.decodedemissiondata", bundle: .module)
    case .disruptedwakeechoes: String(localized: "material.encoded.disruptedwakeechoes", bundle: .module)
    case .embeddedfirmware: String(localized: "material.encoded.embeddedfirmware", bundle: .module)
    case .emissiondata: String(localized: "material.encoded.emissiondata", bundle: .module)
    case .encodedscandata: String(localized: "material.encoded.encodedscandata", bundle: .module)
    case .encryptedfiles: String(localized: "material.encoded.encryptedfiles", bundle: .module)
    case .encryptionarchives: String(localized: "material.encoded.encryptionarchives", bundle: .module)
    case .encryptioncodes: String(localized: "material.encoded.encryptioncodes", bundle: .module)
    case .fsdtelemetry: String(localized: "material.encoded.fsdtelemetry", bundle: .module)
    case .guardian_moduleblueprint: String(localized: "material.encoded.guardian_moduleblueprint", bundle: .module)
    case .hyperspacetrajectories: String(localized: "material.encoded.hyperspacetrajectories", bundle: .module)
    case .industrialfirmware: String(localized: "material.encoded.industrialfirmware", bundle: .module)
    case .legacyfirmware: String(localized: "material.encoded.legacyfirmware", bundle: .module)
    case .scanarchives: String(localized: "material.encoded.scanarchives", bundle: .module)
    case .scandatabanks: String(localized: "material.encoded.scandatabanks", bundle: .module)
    case .scrambledemissiondata: String(localized: "material.encoded.scrambledemissiondata", bundle: .module)
    case .securityfirmware: String(localized: "material.encoded.securityfirmware", bundle: .module)
    case .shieldcyclerecordings: String(localized: "material.encoded.shieldcyclerecordings", bundle: .module)
    case .shielddensityreports: String(localized: "material.encoded.shielddensityreports", bundle: .module)
    case .shieldfrequencydata: String(localized: "material.encoded.shieldfrequencydata", bundle: .module)
    case .shieldpatternanalysis: String(localized: "material.encoded.shieldpatternanalysis", bundle: .module)
    case .shieldsoakanalysis: String(localized: "material.encoded.shieldsoakanalysis", bundle: .module)
    case .symmetrickeys: String(localized: "material.encoded.symmetrickeys", bundle: .module)
    case .wakesolutions: String(localized: "material.encoded.wakesolutions", bundle: .module)
    }
  }
  #endif

  public var grade: Int? {
    switch self {
    case .scrambledemissiondata, .disruptedwakeechoes, .shieldcyclerecordings, .encryptedfiles, .bulkscandata, .legacyfirmware:
      1
    case .archivedemissiondata, .fsdtelemetry, .shieldsoakanalysis, .encryptioncodes, .scanarchives, .consumerfirmware:
      2
    case .emissiondata, .wakesolutions, .shielddensityreports, .symmetrickeys, .scandatabanks, .industrialfirmware:
      3
    case .decodedemissiondata, .hyperspacetrajectories, .shieldpatternanalysis, .encryptionarchives, .encodedscandata, .securityfirmware:
      4
    case .compactemissionsdata, .dataminedwake, .shieldfrequencydata, .adaptiveencryptors, .classifiedscandata, .embeddedfirmware:
      5
    case .ancientbiologicaldata, .ancientculturaldata, .ancienthistoricaldata, .ancientlanguagedata, .ancienttechnologicaldata, .guardian_moduleblueprint:
      nil
    }
  }

  var category: Int {
    1
  }

  var isMaxGrade: Bool? { grade.map { $0 == 5 } }
}
