//
//  MaterialsView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import SwiftUI

struct MaterialsView: View {
  @Environment(EliteJournal.self) var journal

  var body: some View {
    HStack(spacing: 12) {
      List {
        Section("Raw Material Category 1") {
          RawMaterialView(material: .carbon)
          RawMaterialView(material: .vanadium)
          RawMaterialView(material: .niobium)
          RawMaterialView(material: .yttrium)
        }
        Section("Raw Material Category 2") {
          RawMaterialView(material: .phosphorus)
          RawMaterialView(material: .chromium)
          RawMaterialView(material: .molybdenum)
          RawMaterialView(material: .technetium)
        }
        Section("Raw Material Category 3") {
          RawMaterialView(material: .sulphur)
          RawMaterialView(material: .manganese)
          RawMaterialView(material: .cadmium)
          RawMaterialView(material: .ruthenium)
        }
        Section("Raw Material Category 4") {
          RawMaterialView(material: .iron)
          RawMaterialView(material: .zinc)
          RawMaterialView(material: .tin)
          RawMaterialView(material: .selenium)
        }
        Section("Raw Material Category 5") {
          RawMaterialView(material: .nickel)
          RawMaterialView(material: .germanium)
          RawMaterialView(material: .tungsten)
          RawMaterialView(material: .tellurium)
        }
        Section("Raw Material Category 6") {
          RawMaterialView(material: .rhenium)
          RawMaterialView(material: .arsenic)
          RawMaterialView(material: .mercury)
          RawMaterialView(material: .polonium)
        }
        Section("Raw Material Category 7") {
          RawMaterialView(material: .lead)
          RawMaterialView(material: .zirconium)
          RawMaterialView(material: .boron)
          RawMaterialView(material: .antimony)
        }
      }

      List {
        Section("Emission Data") {
          EncodedMaterialView(material: .scrambledemissiondata)
          EncodedMaterialView(material: .archivedemissiondata)
          EncodedMaterialView(material: .emissiondata)
          EncodedMaterialView(material: .decodedemissiondata)
          EncodedMaterialView(material: .compactemissionsdata)
        }
        Section("Wake Scans") {
          EncodedMaterialView(material: .disruptedwakeechoes)
          EncodedMaterialView(material: .fsdtelemetry)
          EncodedMaterialView(material: .wakesolutions)
          EncodedMaterialView(material: .hyperspacetrajectories)
          EncodedMaterialView(material: .dataminedwake)
        }
        Section("Shield Data") {
          EncodedMaterialView(material: .shieldcyclerecordings)
          EncodedMaterialView(material: .shieldsoakanalysis)
          EncodedMaterialView(material: .shielddensityreports)
          EncodedMaterialView(material: .shieldpatternanalysis)
          EncodedMaterialView(material: .shieldfrequencydata)
        }
        Section("Encryption Files") {
          EncodedMaterialView(material: .encryptedfiles)
          EncodedMaterialView(material: .encryptioncodes)
          EncodedMaterialView(material: .symmetrickeys)
          EncodedMaterialView(material: .encryptionarchives)
          EncodedMaterialView(material: .adaptiveencryptors)
        }
        Section("Data Archives") {
          EncodedMaterialView(material: .bulkscandata)
          EncodedMaterialView(material: .scanarchives)
          EncodedMaterialView(material: .scandatabanks)
          EncodedMaterialView(material: .encodedscandata)
          EncodedMaterialView(material: .classifiedscandata)
        }
        Section("Encoded Firmware") {
          EncodedMaterialView(material: .legacyfirmware)
          EncodedMaterialView(material: .consumerfirmware)
          EncodedMaterialView(material: .industrialfirmware)
          EncodedMaterialView(material: .securityfirmware)
          EncodedMaterialView(material: .embeddedfirmware)
        }
      }

      List {
        Section("Chemical") {
          ManufacturedMaterialView(material: .chemicalstorageunits)
          ManufacturedMaterialView(material: .chemicalprocessors)
          ManufacturedMaterialView(material: .chemicaldistillery)
          ManufacturedMaterialView(material: .chemicalmanipulators)
          ManufacturedMaterialView(material: .pharmaceuticalisolators)
        }
        Section("Thermic") {
          ManufacturedMaterialView(material: .temperedalloys)
          ManufacturedMaterialView(material: .heatresistantceramics)
          ManufacturedMaterialView(material: .precipitatedalloys)
          ManufacturedMaterialView(material: .thermicalloys)
          ManufacturedMaterialView(material: .militarygradealloys)
        }
        Section("Heat") {
          ManufacturedMaterialView(material: .heatconductionwiring)
          ManufacturedMaterialView(material: .heatdispersionplate)
          ManufacturedMaterialView(material: .heatexchangers)
          ManufacturedMaterialView(material: .heatvanes)
          ManufacturedMaterialView(material: .protoheatradiators)
        }
        Section("Conductive") {
          ManufacturedMaterialView(material: .basicconductors)
          ManufacturedMaterialView(material: .conductivecomponents)
          ManufacturedMaterialView(material: .conductiveceramics)
          ManufacturedMaterialView(material: .conductivepolymers)
          ManufacturedMaterialView(material: .biotechconductors)
        }
        Section("Mechanical Components") {
          ManufacturedMaterialView(material: .mechanicalscrap)
          ManufacturedMaterialView(material: .mechanicalequipment)
          ManufacturedMaterialView(material: .mechanicalcomponents)
          ManufacturedMaterialView(material: .configurablecomponents)
          ManufacturedMaterialView(material: .improvisedcomponents)
        }
        Section("Capacitors") {
          ManufacturedMaterialView(material: .gridresistors)
          ManufacturedMaterialView(material: .hybridcapacitors)
          ManufacturedMaterialView(material: .electrochemicalarrays)
          ManufacturedMaterialView(material: .polymercapacitors)
          ManufacturedMaterialView(material: .militarysupercapacitors)
        }
        Section("Shielding") {
          ManufacturedMaterialView(material: .wornshieldemitters)
          ManufacturedMaterialView(material: .shieldemitters)
          ManufacturedMaterialView(material: .shieldingsensors)
          ManufacturedMaterialView(material: .compoundshielding)
          ManufacturedMaterialView(material: .imperialshielding)
        }
        Section("Composite") {
          ManufacturedMaterialView(material: .compactcomposites)
          ManufacturedMaterialView(material: .filamentcomposites)
          ManufacturedMaterialView(material: .highdensitycomposites)
          ManufacturedMaterialView(material: .fedproprietarycomposites)
          ManufacturedMaterialView(material: .fedcorecomposites)
        }
        Section("Crystals") {
          ManufacturedMaterialView(material: .crystalshards)
          ManufacturedMaterialView(material: .uncutfocuscrystals)
          ManufacturedMaterialView(material: .focuscrystals)
          ManufacturedMaterialView(material: .refinedfocuscrystals)
          ManufacturedMaterialView(material: .exquisitefocuscrystals)
        }
        Section("Alloys") {
          ManufacturedMaterialView(material: .salvagedalloys)
          ManufacturedMaterialView(material: .galvanisingalloys)
          ManufacturedMaterialView(material: .phasealloys)
          ManufacturedMaterialView(material: .protolightalloys)
          ManufacturedMaterialView(material: .protoradiolicalloys)
        }
      }
    }
  }
}

struct GenericMaterialView: View {
  let grade: Int?
  let name: LocalizedStringResource
  let count: Int

  var body: some View {
    HStack {
      if let grade {
        Text("G\(grade)").monospacedDigit()
      }
      Text(name)
      Spacer()
      Text(String(count)).monospacedDigit()
    }
  }
}

struct RawMaterialView: View {
  @Environment(EliteJournal.self) var journal

  let material: RawMaterial

  var body: some View {
    let count = journal.rawMaterials[material] ?? 0
    GenericMaterialView(
      grade: material.grade,
      name: material.localizedName,
      count: count
    )
  }
}

struct ManufacturedMaterialView: View {
  @Environment(EliteJournal.self) var journal

  let material: ManufacturedMaterial

  var body: some View {
    let count = journal.manufacturedMaterials[material] ?? 0
    GenericMaterialView(
      grade: material.grade,
      name: material.localizedName,
      count: count
    )
  }
}

struct EncodedMaterialView: View {
  @Environment(EliteJournal.self) var journal

  let material: EncodedMaterial

  var body: some View {
    let count = journal.encodedMaterials[material] ?? 0
    GenericMaterialView(
      grade: material.grade,
      name: material.localizedName,
      count: count
    )
  }
}
