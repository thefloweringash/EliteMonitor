//
//  MaterialsView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/09.
//

import SwiftData
import SwiftUI

struct MaterialTableRow: Identifiable {
  let group: MaterialGroup
  let g1: AnyMaterial
  let g2: AnyMaterial
  let g3: AnyMaterial
  let g4: AnyMaterial
  let g5: AnyMaterial?

  var id: MaterialGroup { group }
  var name: LocalizedStringResource { group.localizedName }

  init(
    _ group: MaterialGroup,
    _ g1: RawMaterial,
    _ g2: RawMaterial,
    _ g3: RawMaterial,
    _ g4: RawMaterial,
  ) {
    self.group = group
    self.g1 = .raw(g1)
    self.g2 = .raw(g2)
    self.g3 = .raw(g3)
    self.g4 = .raw(g4)
    g5 = nil
  }

  init(
    _ group: MaterialGroup,
    _ g1: EncodedMaterial,
    _ g2: EncodedMaterial,
    _ g3: EncodedMaterial,
    _ g4: EncodedMaterial,
    _ g5: EncodedMaterial
  ) {
    self.group = group
    self.g1 = .encoded(g1)
    self.g2 = .encoded(g2)
    self.g3 = .encoded(g3)
    self.g4 = .encoded(g4)
    self.g5 = .encoded(g5)
  }

  init(
    _ group: MaterialGroup,
    _ g1: ManufacturedMaterial,
    _ g2: ManufacturedMaterial,
    _ g3: ManufacturedMaterial,
    _ g4: ManufacturedMaterial,
    _ g5: ManufacturedMaterial
  ) {
    self.group = group
    self.g1 = .manufactured(g1)
    self.g2 = .manufactured(g2)
    self.g3 = .manufactured(g3)
    self.g4 = .manufactured(g4)
    self.g5 = .manufactured(g5)
  }
}

struct MaterialCell: View {
  let material: AnyMaterial
  let count: Int
  let incoming: Int?
  let emphasis: Emphasis

  var body: some View {
    ZStack {
      let cap = material.cap!
      let full = count >= cap - 2

      let spaceAvailable = cap - count
      let spaceConstrained = if let incoming {
        incoming > spaceAvailable
      } else {
        false
      }

      let emphasised = (emphasis.contains(.exceedingCap) && spaceConstrained) || (emphasis.contains(.withCapacity) && !full && !material.isMaxGrade!)
      let diminished = !emphasis.isEmpty && !emphasised

      if !diminished {
        GeometryReader { geom in
          ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3)
              .fill(.progressBackground)
            if let incoming {
              RoundedRectangle(cornerRadius: 3)
                .fill(.progressProvisional)
                .frame(width: geom.size.width * min(1.0, CGFloat(count + incoming) / CGFloat(cap)))
            }
            RoundedRectangle(cornerRadius: 3)
              .fill(.progressForeground)
              .frame(width: geom.size.width * CGFloat(count) / CGFloat(cap))
          }
        }
      }

      HStack {
        Text(material.localizedName)
          .frame(maxWidth: .infinity, alignment: .leading)
        Text(count.formatted())
          .monospacedDigit()

        if let incoming {
          Text("Incoming(quantity=\(incoming.formatted()))")
          if incoming > spaceAvailable {
            Text("InlineIncomingOverflow(quantity=\(incoming - spaceAvailable),icon=\(Image(systemName: "exclamationmark.circle")))")
          }
        }
      }
      .padding(.horizontal, 4)
      .padding(.vertical, 2)
    }
  }
}

struct MaterialsView: View {
  @State var missionRewards: [MissionReward] = []

  var body: some View {
    HSplitView {
      MaterialsTable()
        .frame(minWidth: 400)
//        .layoutPriority(1)
      IncomingMaterials()
        .frame(minWidth: 100)
    }
  }
}

struct IncomingMaterials: View {
  @Query var missionRewards: [MissionReward]
  @Environment(\.modelContext) private var modelContext
  @State var selectedMissionRewards: Set<PersistentIdentifier> = []

  @State var newMaterial: AnyMaterial?
  @State var quantity: Int?

  enum InputField {
    case material
    case quantity
  }

  @FocusState var focusedInputField: InputField?

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        MaterialSelectorTextField(material: $newMaterial, onSubmit: {
          focusedInputField = .quantity
        })
        .frame(minWidth: 200)
        .focused($focusedInputField, equals: .material)
        // OnSubmit cannot work here:
        // https://christiantietze.de/posts/2023/06/swiftui-onsubmit/
        //  .onSubmit {
        //    focusedInputField = .quantity
        //  }

        TextField(
          value: $quantity,
          format: .number,
          prompt: Text("Qty"),
          label: {
            Text("Quantity")
          }
        )
        .focused($focusedInputField, equals: .quantity)
        .frame(minWidth: 30)
        .onSubmit {
          guard let newMaterial, let quantity else { return }

          modelContext.insert(MissionReward(material: newMaterial, count: quantity))

          self.newMaterial = nil
          self.quantity = nil

          focusedInputField = .material
        }
      }
      .padding(8)
      List(selection: $selectedMissionRewards) {
        ForEach(missionRewards) { reward in
          Text("Reward(quantity=\(Text(reward.count.formatted()).monospacedDigit()),material=\(reward.material.localizedName))")
        }
        // This is very iOS style swipe-to-delete
        .onDelete { indexes in
          for i in indexes {
            modelContext.delete(missionRewards[i])
          }
        }
      }
      .onDeleteCommand {
        try! modelContext.delete(model: MissionReward.self, where: #Predicate<MissionReward> { x in
          selectedMissionRewards.contains(x.id)
        })
      }
    }
  }
}

struct Emphasis: OptionSet {
  let rawValue: Int

  static let withCapacity: Emphasis = .init(rawValue: 1 << 0)
  static let exceedingCap: Emphasis = .init(rawValue: 1 << 1)
}

struct MaterialsTable: View {
  @Query var missionRewards: [MissionReward]

  @Environment(EliteJournal.self) var journal

  @State var emphasis: Emphasis = []
  @State var incomingMaterials: [AnyMaterial: Int] = [:]

  @inlinable
  func cell(_ m: AnyMaterial) -> MaterialCell {
    MaterialCell(
      material: m,
      count: journal.materialBalance(material: m),
      incoming: incomingMaterials[m],
      emphasis: emphasis
    )
  }

  var body: some View {
    Table(of: MaterialTableRow.self) {
      TableColumn("Name") { Text($0.name) }
      TableColumn("G1") { cell($0.g1) }
      TableColumn("G2") { cell($0.g2) }
      TableColumn("G3") { cell($0.g3) }
      TableColumn("G4") { cell($0.g4) }
      TableColumn("G5") { row in
        if let g5 = row.g5 {
          cell(g5)
        }
      }
    } rows: {
      Section("Raw Materials") {
        TableRow(MaterialTableRow(.rawMaterials1, .carbon, .vanadium, .niobium, .yttrium))
        TableRow(MaterialTableRow(.rawMaterials2, .phosphorus, .chromium, .molybdenum, .technetium))
        TableRow(MaterialTableRow(.rawMaterials3, .sulphur, .manganese, .cadmium, .ruthenium))
        TableRow(MaterialTableRow(.rawMaterials4, .iron, .zinc, .tin, .selenium))
        TableRow(MaterialTableRow(.rawMaterials5, .nickel, .germanium, .tungsten, .tellurium))
        TableRow(MaterialTableRow(.rawMaterials6, .rhenium, .arsenic, .mercury, .polonium))
        TableRow(MaterialTableRow(.rawMaterials7, .lead, .zirconium, .boron, .antimony))
      }

      Section("Encoded Materials") {
        TableRow(MaterialTableRow(.emissionData, .scrambledemissiondata, .archivedemissiondata, .emissiondata, .decodedemissiondata, .compactemissionsdata))
        TableRow(MaterialTableRow(.wakeScans, .disruptedwakeechoes, .fsdtelemetry, .wakesolutions, .hyperspacetrajectories, .dataminedwake))
        TableRow(MaterialTableRow(.shieldData, .shieldcyclerecordings, .shieldsoakanalysis, .shielddensityreports, .shieldpatternanalysis, .shieldfrequencydata))
        TableRow(MaterialTableRow(.encryptionFiles, .encryptedfiles, .encryptioncodes, .symmetrickeys, .encryptionarchives, .adaptiveencryptors))
        TableRow(MaterialTableRow(.dataArchives, .bulkscandata, .scanarchives, .scandatabanks, .encodedscandata, .classifiedscandata))
        TableRow(MaterialTableRow(.encodedFirmware, .legacyfirmware, .consumerfirmware, .industrialfirmware, .securityfirmware, .embeddedfirmware))
      }

      Section("Manufactured Materials") {
        TableRow(MaterialTableRow(.chemical, .chemicalstorageunits, .chemicalprocessors, .chemicaldistillery, .chemicalmanipulators, .pharmaceuticalisolators))
        TableRow(MaterialTableRow(.thermic, .temperedalloys, .heatresistantceramics, .precipitatedalloys, .thermicalloys, .militarygradealloys))
        TableRow(MaterialTableRow(.heat, .heatconductionwiring, .heatdispersionplate, .heatexchangers, .heatvanes, .protoheatradiators))
        TableRow(MaterialTableRow(.conductive, .basicconductors, .conductivecomponents, .conductiveceramics, .conductivepolymers, .biotechconductors))
        TableRow(MaterialTableRow(.mechanicalComponents, .mechanicalscrap, .mechanicalequipment, .mechanicalcomponents, .configurablecomponents, .improvisedcomponents))
        TableRow(MaterialTableRow(.capacitors, .gridresistors, .hybridcapacitors, .electrochemicalarrays, .polymercapacitors, .militarysupercapacitors))
        TableRow(MaterialTableRow(.shielding, .wornshieldemitters, .shieldemitters, .shieldingsensors, .compoundshielding, .imperialshielding))
        TableRow(MaterialTableRow(.composite, .compactcomposites, .filamentcomposites, .highdensitycomposites, .fedproprietarycomposites, .fedcorecomposites))
        TableRow(MaterialTableRow(.crystals, .crystalshards, .uncutfocuscrystals, .focuscrystals, .refinedfocuscrystals, .exquisitefocuscrystals))
        TableRow(MaterialTableRow(.alloys, .salvagedalloys, .galvanisingalloys, .phasealloys, .protolightalloys, .protoradiolicalloys))
      }
    }
    .toolbar {
      ToolbarItem {
        Button {
          emphasis.formSymmetricDifference(.exceedingCap)
        } label: {
          Label {
            Text("Items exceeding cap")
          } icon: {
            Image(systemName: emphasis.contains(.exceedingCap) ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
          }
        }
      }

      ToolbarItem {
        Button {
          emphasis.formSymmetricDifference(.withCapacity)
        } label: {
          Label {
            Text("Items with Capacity")
          } icon: {
            Image(systemName: emphasis.contains(.withCapacity) ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
          }
        }
      }
    }
    .onChange(of: missionRewards, initial: true) {
      incomingMaterials = Dictionary(missionRewards.lazy.map { ($0.material, $0.count) }, uniquingKeysWith: +)
    }
  }
}
