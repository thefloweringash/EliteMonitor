//
//  CarrierJumpState.swift
//  EliteMonitorCore
//
//  Created by Andrew Childs on 2025/07/20.
//

import Foundation

public enum CarrierJumpState: Sendable {
  case scheduled(at: Date, destination: BodyLocation)
  case completed(at: Date, estimatedCooldownEnd: Date)
}
