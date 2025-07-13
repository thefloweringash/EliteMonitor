//
//  MaterialGroup.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/07/11.
//

import Foundation

enum MaterialGroup: Hashable {
  case rawMaterials1, rawMaterials2, rawMaterials3, rawMaterials4, rawMaterials5, rawMaterials6, rawMaterials7
  case emissionData, wakeScans, shieldData, encryptionFiles, dataArchives, encodedFirmware
  case chemical, thermic, heat, conductive, mechanicalComponents, capacitors, shielding, composite, crystals, alloys

  var localizedName: LocalizedStringResource {
    switch self {
    case .rawMaterials1: "Raw Material Category 1"
    case .rawMaterials2: "Raw Material Category 2"
    case .rawMaterials3: "Raw Material Category 3"
    case .rawMaterials4: "Raw Material Category 4"
    case .rawMaterials5: "Raw Material Category 5"
    case .rawMaterials6: "Raw Material Category 6"
    case .rawMaterials7: "Raw Material Category 7"
    case .emissionData: "Emission Data"
    case .wakeScans: "Wake Scans"
    case .shieldData: "Shield Data"
    case .encryptionFiles: "Encryption Files"
    case .dataArchives: "Data Archives"
    case .encodedFirmware: "Encoded Firmware"
    case .chemical: "Chemical"
    case .thermic: "Thermic"
    case .heat: "Heat"
    case .conductive: "Conductive"
    case .mechanicalComponents: "Mechanical Components"
    case .capacitors: "Capacitors"
    case .shielding: "Shielding"
    case .composite: "Composite"
    case .crystals: "Crystals"
    case .alloys: "Alloys"
    }
  }
}
