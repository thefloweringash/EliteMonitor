//
//  BodyLocation.swift
//  EliteMonitorCore
//
//  Created by Andrew Childs on 2025/07/20.
//

import EliteGameData

public struct BodyLocation: Sendable {
  public let system: String
  public let body: String?

  public init(system: String, body: String?) {
    self.system = system
    self.body = body
  }
}

public extension CarrierJumpRequestDetails {
  var destination: BodyLocation {
    BodyLocation(system: system, body: body)
  }
}

public extension BodyLocation {
  var description: String {
    if let ladderPos = BoozeCruise.ladderPosition(system: system) {
      "\(body ?? system) [\(ladderPos)]"
    } else {
      body ?? system
    }
  }
}
