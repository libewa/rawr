//
//  ContentView.swift
//  rawr-watch Watch App
//
//  Created by Linus Warnatz on 19.06.25.
//

import HealthKit
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) var context
  @Query var items: [Item]
  @Query(filter: Item.isInTodayPredicate, sort: \Item.timestamp, animation: .default) var itemsToday: [Item]
  @State private var amount: Double = 200
  @AppStorage("dailyGoal") var maxAmount: Double = 2000
  @State var error: Error?
  @State var showError = false

  let healthTypes: Set = [
    HKQuantityType(.dietaryWater)
  ]

  private var totalToday: Double {
    let total = itemsToday.compactMap({ $0.amount }).reduce(0, +)
    print("Total today: \(total)ml")
    return total
  }

  var body: some View {
    VStack {
      Text(
        "\(Int(totalToday))\u{202f}ml / \(Int(maxAmount))\u{202f}ml today"
      )
      WaterLoggingButton(
        amount: $amount,
        hintStyle: .amount,
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
      .handGestureShortcut(.primaryAction, isEnabled: amount > 0)
      .focusable(true)
      .digitalCrownRotation(
        $amount,
        from: 0,
        through: maxAmount,
        by: 10
      )
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          SettingsView()
        } label: {
          Label("Settings", systemImage: "gearshape")
        }
      }
    }
    .onAppear {
      Task {
        try await enableAndSyncHealthIntegration(
          types: healthTypes
        )
      }
    }
    .alert("An error occurred", isPresented: $showError) {
      Button("OK", role: .cancel) {}
    } message: {
      VStack {
        Text(error?.localizedDescription ?? "Unknown error")
        Text("Try restarting the app from “Recent Apps”.")
      }
    }
  }
}

#Preview {
  ContentView()
}
