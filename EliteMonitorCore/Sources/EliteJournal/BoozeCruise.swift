//
//  BoozeCruise.swift
//  EliteMonitorCore
//
//  Created by Andrew Childs on 2025/07/20.
//

import Foundation

public enum BoozeCruise {
  //  N-0: HIP 58832 (Rackham’s Peak)
  //  N-1: HD 105341 (Carrier Bottleneck System)
  //  N-2: HD 104495 (Carrier Parking System)
  //  N-3: HIP 57784
  //  N-4: HIP 57478
  //  N-5: HIP 56843
  //  N-6: HD 104392
  //  N-7: HD 102779
  //  N-8: HD 102000
  //  N-9: HD 104785
  //  N10: HD 105548
  //  N11: HD 107865
  //  N12: Plaa Trua WQ-C d13-0
  //  N13: Plaa Trua QL-B c27-0
  //  N14: Wregoe OP-D b58-0
  //  N15: Wregoe ZE-B c28-2
  //  N16: Gali (Chadwick Dock)
  public static let ladder: [String] = [
    "HIP 58832",
    "HD 105341",
    "HD 104495",
    "HIP 57784",
    "HIP 57478",
    "HIP 56843",
    "HD 104392",
    "HD 102779",
    "HD 102000",
    "HD 104785",
    "HD 105548",
    "HD 107865",
    "Plaa Trua WQ-C d13-0",
    "Plaa Trua QL-B c27-0",
    "Wregoe OP-D b58-0",
    "Wregoe ZE-B c28-2",
    "Gali",
  ]

  public static func ladderPosition(system: String) -> String? {
    ladder.firstIndex(of: system).map { "N\($0)" }
  }
}
