//
//  EncodedMaterial.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import Foundation

enum EncodedMaterial: String, RawRepresentable, Decodable, Material, CaseIterable {
  var asAnyMaterial: AnyMaterial { .encoded(self) }

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

  var localizedName: LocalizedStringResource {
    switch self {
    case .adaptiveencryptors: "material.encoded.adaptiveencryptors"
    case .ancientbiologicaldata: "material.encoded.ancientbiologicaldata"
    case .ancientculturaldata: "material.encoded.ancientculturaldata"
    case .ancienthistoricaldata: "material.encoded.ancienthistoricaldata"
    case .ancientlanguagedata: "material.encoded.ancientlanguagedata"
    case .ancienttechnologicaldata: "material.encoded.ancienttechnologicaldata"
    case .archivedemissiondata: "material.encoded.archivedemissiondata"
    case .bulkscandata: "material.encoded.bulkscandata"
    case .classifiedscandata: "material.encoded.classifiedscandata"
    case .compactemissionsdata: "material.encoded.compactemissionsdata"
    case .consumerfirmware: "material.encoded.consumerfirmware"
    case .dataminedwake: "material.encoded.dataminedwake"
    case .decodedemissiondata: "material.encoded.decodedemissiondata"
    case .disruptedwakeechoes: "material.encoded.disruptedwakeechoes"
    case .embeddedfirmware: "material.encoded.embeddedfirmware"
    case .emissiondata: "material.encoded.emissiondata"
    case .encodedscandata: "material.encoded.encodedscandata"
    case .encryptedfiles: "material.encoded.encryptedfiles"
    case .encryptionarchives: "material.encoded.encryptionarchives"
    case .encryptioncodes: "material.encoded.encryptioncodes"
    case .fsdtelemetry: "material.encoded.fsdtelemetry"
    case .guardian_moduleblueprint: "material.encoded.guardian_moduleblueprint"
    case .hyperspacetrajectories: "material.encoded.hyperspacetrajectories"
    case .industrialfirmware: "material.encoded.industrialfirmware"
    case .legacyfirmware: "material.encoded.legacyfirmware"
    case .scanarchives: "material.encoded.scanarchives"
    case .scandatabanks: "material.encoded.scandatabanks"
    case .scrambledemissiondata: "material.encoded.scrambledemissiondata"
    case .securityfirmware: "material.encoded.securityfirmware"
    case .shieldcyclerecordings: "material.encoded.shieldcyclerecordings"
    case .shielddensityreports: "material.encoded.shielddensityreports"
    case .shieldfrequencydata: "material.encoded.shieldfrequencydata"
    case .shieldpatternanalysis: "material.encoded.shieldpatternanalysis"
    case .shieldsoakanalysis: "material.encoded.shieldsoakanalysis"
    case .symmetrickeys: "material.encoded.symmetrickeys"
    case .wakesolutions: "material.encoded.wakesolutions"
    }
  }

  var grade: Int? {
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
}
