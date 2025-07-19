//
//  MaterialGroup.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/07/11.
//

import Foundation

public enum MaterialGroup: Hashable {
  case rawMaterials1, rawMaterials2, rawMaterials3, rawMaterials4, rawMaterials5, rawMaterials6, rawMaterials7
  case emissionData, wakeScans, shieldData, encryptionFiles, dataArchives, encodedFirmware
  case chemical, thermic, heat, conductive, mechanicalComponents, capacitors, shielding, composite, crystals, alloys

  #if Localization
  public var localizedName: String {
    switch self {
    case .rawMaterials1: String(localized: "Raw Material Category 1", bundle: .module)
    case .rawMaterials2: String(localized: "Raw Material Category 2", bundle: .module)
    case .rawMaterials3: String(localized: "Raw Material Category 3", bundle: .module)
    case .rawMaterials4: String(localized: "Raw Material Category 4", bundle: .module)
    case .rawMaterials5: String(localized: "Raw Material Category 5", bundle: .module)
    case .rawMaterials6: String(localized: "Raw Material Category 6", bundle: .module)
    case .rawMaterials7: String(localized: "Raw Material Category 7", bundle: .module)
    case .emissionData: String(localized: "Emission Data", bundle: .module)
    case .wakeScans: String(localized: "Wake Scans", bundle: .module)
    case .shieldData: String(localized: "Shield Data", bundle: .module)
    case .encryptionFiles: String(localized: "Encryption Files", bundle: .module)
    case .dataArchives: String(localized: "Data Archives", bundle: .module)
    case .encodedFirmware: String(localized: "Encoded Firmware", bundle: .module)
    case .chemical: String(localized: "Chemical", bundle: .module)
    case .thermic: String(localized: "Thermic", bundle: .module)
    case .heat: String(localized: "Heat", bundle: .module)
    case .conductive: String(localized: "Conductive", bundle: .module)
    case .mechanicalComponents: String(localized: "Mechanical Components", bundle: .module)
    case .capacitors: String(localized: "Capacitors", bundle: .module)
    case .shielding: String(localized: "Shielding", bundle: .module)
    case .composite: String(localized: "Composite", bundle: .module)
    case .crystals: String(localized: "Crystals", bundle: .module)
    case .alloys: String(localized: "Alloys", bundle: .module)
    }
  }
  #endif
}
