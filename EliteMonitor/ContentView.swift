//
//  ContentView.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/02/08.
//

import SwiftUI

struct ContentView: View {
  @State var viewModel = JournalViewModel()

  var body: some View {
    VStack {
      List {
        ForEach(viewModel.events, id: \.0) { event in
          VStack(alignment: .leading) {
            Text(event.1.type)
            Text(event.1.timestamp.formatted())
          }
        }
      }
      .defaultScrollAnchor(.bottom)
    }
    .task {
      await viewModel.monitor()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
