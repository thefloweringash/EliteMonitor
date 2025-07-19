//
//  MissionReward.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/07/13.
//

import EliteGameData
import Foundation
import SwiftData

@Model
class MissionReward {
  var material: AnyMaterial
  var count: Int

  init(material: AnyMaterial, count: Int) {
    self.material = material
    self.count = count
  }
}
