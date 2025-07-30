//
//  ContentView.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import Foundation
import HealthKit
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) var context
  @Query var items: [Item]
  @Query(filter: Item.isInTodayPredicate, sort: \Item.timestamp, animation: .default) var itemsToday: [Item]
  @Query var notifications: [Notification]
  @State var amount = 200.0
  @State private var isDeleting = false
  @State private var isProcessing = false
  @State var error: Error?
  @State var showError = false

  private var totalToday: Double {
    itemsToday.compactMap({ $0.amount }).reduce(0, +)
  }

  let healthTypes: Set = [
    HKQuantityType(.dietaryWater)
  ]

  var body: some View {
    VStack(alignment: .center) {
      Text("Welcome to Rawr!")
        .font(.title)
      Text("(Roughly Approximate Water Reminder)")
        .font(.subheadline)
      Divider()
      Spacer()
      Text("You drank \(Int(totalToday))\u{202f}ml today.")
      TargetProgressView(amount: totalToday)
      HStack {
        TextField(
          "Amount",
          value: $amount,
          formatter: NumberFormatter()
        )
        .multilineTextAlignment(.center)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.decimalPad)
        Text("ml")
      }
      .frame(width: 100)
      WaterLoggingButton(
        amount: $amount,
        action: .closure({
          do {
            try logWater(
              amount: $0,
              totalToday: totalToday,
              modelContext: context
            )
          } catch {
            self.error = error
            self.showError = true
          }
        })
      )
      Spacer()
    }
    .onAppear {
      Task {
        try await enableAndSyncHealthIntegration(
          types: healthTypes
        )
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
          Label("Open App Settings", systemImage: "gearshape")
        }
      }
    }
    .alert("An error occurred", isPresented: $showError) {
      Button("OK", role: .cancel) {}
    } message: {
      VStack {
        Text(error?.localizedDescription ?? "Unknown error")
        Text("Try restarting the app from the App Switcher.")
      }
    }
    .padding()
  }
}

#Preview {
  NavigationStack {
    ContentView()
  }
    .modelContainer(for: Item.self, inMemory: true)
}
