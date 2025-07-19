//
//  CarrierFuelView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/06/28.
//

import Foundation
import SwiftUI

struct CarrierFuelView: View {
  let fuel: Int

  var body: some View {
    HStack {
      ZStack {
        Circle()
          .stroke(Color.gray, lineWidth: 5)

        Circle()
          .trim(to: CGFloat(fuel) / 1000)
          .stroke(lineWidth: 5)
          .rotation(.degrees(-90))
      }
      .padding(5)
      .frame(width: 24, height: 24)
      Text(percentage)
    }
  }

  var percentage: String {
    (fuel / 10).formatted(.percent)
  }
}

#Preview {
  CarrierFuelView(fuel: 50)
}
