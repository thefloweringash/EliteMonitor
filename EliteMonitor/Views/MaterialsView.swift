//
//  MaterialsView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import SwiftUI

struct MaterialTableRow: Identifiable {
  var id: String { name.key }
  let name: LocalizedStringResource
  let g1: AnyMaterial
  let g2: AnyMaterial
  let g3: AnyMaterial
  let g4: AnyMaterial
  let g5: AnyMaterial?

  init(
    _ name: LocalizedStringResource,
    _ g1: RawMaterial,
    _ g2: RawMaterial,
    _ g3: RawMaterial,
    _ g4: RawMaterial,
  ) {
    self.name = name
    self.g1 = .raw(g1)
    self.g2 = .raw(g2)
    self.g3 = .raw(g3)
    self.g4 = .raw(g4)
    g5 = nil
  }

  init(
    _ name: LocalizedStringResource,
    _ g1: EncodedMaterial,
    _ g2: EncodedMaterial,
    _ g3: EncodedMaterial,
    _ g4: EncodedMaterial,
    _ g5: EncodedMaterial
  ) {
    self.name = name
    self.g1 = .encoded(g1)
    self.g2 = .encoded(g2)
    self.g3 = .encoded(g3)
    self.g4 = .encoded(g4)
    self.g5 = .encoded(g5)
  }

  init(
    _ name: LocalizedStringResource,
    _ g1: ManufacturedMaterial,
    _ g2: ManufacturedMaterial,
    _ g3: ManufacturedMaterial,
    _ g4: ManufacturedMaterial,
    _ g5: ManufacturedMaterial
  ) {
    self.name = name
    self.g1 = .manufactured(g1)
    self.g2 = .manufactured(g2)
    self.g3 = .manufactured(g3)
    self.g4 = .manufactured(g4)
    self.g5 = .manufactured(g5)
  }
}

struct MaterialCell: View {
  @Environment(EliteJournal.self) var journal

  init(_ material: AnyMaterial) {
    self.material = material
  }

  let material: AnyMaterial

  var body: some View {
    let count = journal.materialBalance(material: material)
    ZStack {
      let cap = material.cap!
      GeometryReader { geom in
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: 3)
            .fill(.progressBackground)
          RoundedRectangle(cornerRadius: 3)
            .fill(.progressForeground)
            .frame(width: geom.size.width * CGFloat(count) / CGFloat(cap))
        }
      }
      HStack {
        Text(material.localizedName)
          .frame(maxWidth: .infinity, alignment: .leading)
        Text(count.formatted())
          .monospacedDigit()
      }
      .padding(.horizontal, 4)
      .padding(.vertical, 2)
    }
  }
}

struct MaterialsView: View {
  @Environment(EliteJournal.self) var journal

  var body: some View {
    Table(of: MaterialTableRow.self) {
      TableColumn("Name") { Text($0.name) }
      TableColumn("G1") { MaterialCell($0.g1) }
      TableColumn("G2") { MaterialCell($0.g2) }
      TableColumn("G3") { MaterialCell($0.g3) }
      TableColumn("G4") { MaterialCell($0.g4) }
      TableColumn("G5") { row in
        if let g5 = row.g5 {
          MaterialCell(g5)
        }
      }
    } rows: {
      Section("Raw Materials") {
        TableRow(MaterialTableRow("Raw Material Category 1", .carbon, .vanadium, .niobium, .yttrium))
        TableRow(MaterialTableRow("Raw Material Category 2", .phosphorus, .chromium, .molybdenum, .technetium))
        TableRow(MaterialTableRow("Raw Material Category 3", .sulphur, .manganese, .cadmium, .ruthenium))
        TableRow(MaterialTableRow("Raw Material Category 4", .iron, .zinc, .tin, .selenium))
        TableRow(MaterialTableRow("Raw Material Category 5", .nickel, .germanium, .tungsten, .tellurium))
        TableRow(MaterialTableRow("Raw Material Category 6", .rhenium, .arsenic, .mercury, .polonium))
        TableRow(MaterialTableRow("Raw Material Category 7", .lead, .zirconium, .boron, .antimony))
      }

      Section("Encoded Materials") {
        TableRow(MaterialTableRow("Emission Data", .scrambledemissiondata, .archivedemissiondata, .emissiondata, .decodedemissiondata, .compactemissionsdata))
        TableRow(MaterialTableRow("Wake Scans", .disruptedwakeechoes, .fsdtelemetry, .wakesolutions, .hyperspacetrajectories, .dataminedwake))
        TableRow(MaterialTableRow("Shield Data", .shieldcyclerecordings, .shieldsoakanalysis, .shielddensityreports, .shieldpatternanalysis, .shieldfrequencydata))
        TableRow(MaterialTableRow("Encryption Files", .encryptedfiles, .encryptioncodes, .symmetrickeys, .encryptionarchives, .adaptiveencryptors))
        TableRow(MaterialTableRow("Data Archives", .bulkscandata, .scanarchives, .scandatabanks, .encodedscandata, .classifiedscandata))
        TableRow(MaterialTableRow("Encoded Firmware", .legacyfirmware, .consumerfirmware, .industrialfirmware, .securityfirmware, .embeddedfirmware))
      }
      Section("Manufactured Materials") {
        TableRow(MaterialTableRow("Chemical", .chemicalstorageunits, .chemicalprocessors, .chemicaldistillery, .chemicalmanipulators, .pharmaceuticalisolators))
        TableRow(MaterialTableRow("Thermic", .temperedalloys, .heatresistantceramics, .precipitatedalloys, .thermicalloys, .militarygradealloys))
        TableRow(MaterialTableRow("Heat", .heatconductionwiring, .heatdispersionplate, .heatexchangers, .heatvanes, .protoheatradiators))
        TableRow(MaterialTableRow("Conductive", .basicconductors, .conductivecomponents, .conductiveceramics, .conductivepolymers, .biotechconductors))
        TableRow(MaterialTableRow("Mechanical Components", .mechanicalscrap, .mechanicalequipment, .mechanicalcomponents, .configurablecomponents, .improvisedcomponents))
        TableRow(MaterialTableRow("Capacitors", .gridresistors, .hybridcapacitors, .electrochemicalarrays, .polymercapacitors, .militarysupercapacitors))
        TableRow(MaterialTableRow("Shielding", .wornshieldemitters, .shieldemitters, .shieldingsensors, .compoundshielding, .imperialshielding))
        TableRow(MaterialTableRow("Composite", .compactcomposites, .filamentcomposites, .highdensitycomposites, .fedproprietarycomposites, .fedcorecomposites))
        TableRow(MaterialTableRow("Crystals", .crystalshards, .uncutfocuscrystals, .focuscrystals, .refinedfocuscrystals, .exquisitefocuscrystals))
        TableRow(MaterialTableRow("Alloys", .salvagedalloys, .galvanisingalloys, .phasealloys, .protolightalloys, .protoradiolicalloys))
      }
    }
  }
}
