//
//  CarrierSpaceView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/06/28.
//

import Charts
import EliteGameData
import SwiftUI

struct CarrierSpaceView: View {
  let spaceUsage: CarrierStatsDetails.SpaceUsage

  var body: some View {
    Chart {
      bar(name: "Crew", value: \.crew)
      bar(name: "Cargo ", value: \.cargo)
      bar(name: "Cargo (Reserved) ", value: \.cargoSpaceReserved)
      bar(name: "Ship Packs", value: \.shipPacks)
      bar(name: "Module Packs", value: \.modulePacks)
      bar(name: "Other", value: otherSpace)
    }
    .chartXScale(domain: 0...spaceUsage.totalCapacity)
  }

  @ChartContentBuilder func bar(
    name: String,
    value: KeyPath<CarrierStatsDetails.SpaceUsage, Int>
  ) -> some ChartContent {
    let value = spaceUsage[keyPath: value]
    bar(name: name, value: value)
  }

  @ChartContentBuilder func bar(
    name: String,
    value: Int,
  ) -> some ChartContent {
    if value != 0 {
      BarMark(
        x: .value(name, value),
      )
      .foregroundStyle(by: .value("Type", name))
    }
  }

  var otherSpace: Int {
    spaceUsage.totalCapacity - (
      spaceUsage.crew +
        spaceUsage.cargo +
        spaceUsage.cargoSpaceReserved +
        spaceUsage.shipPacks +
        spaceUsage.modulePacks +
        spaceUsage.freeSpace
    )
  }
}

#Preview {
  CarrierSpaceView(
    spaceUsage: .init(
      totalCapacity: 25000,
      crew: 1000,
      cargo: 2000,
      cargoSpaceReserved: 0,
      shipPacks: 0,
      modulePacks: 0,
      freeSpace: 25000 - 3000
    )
  )
  .padding()
}
