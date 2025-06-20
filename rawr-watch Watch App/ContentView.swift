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
    @State private var amount: Double = 200
    @AppStorage("dailyGoal") var maxAmount: Double = 2000

    let healthTypes: Set = [
        HKQuantityType(.dietaryWater)
    ]

    private var totalToday: Double {
        let total = items.filter({
            Calendar.current.isDateInToday($0.timestamp)
        }).compactMap({ $0.amount }).reduce(0, +)
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
                showAmount: true,
                action: .closure({
                    logWater(
                        amount: $0,
                        totalToday: totalToday,
                        modelContext: context
                    )
                })
            )
            .onChange(of: amount) {
                print(amount)
            }
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
    }
}

#Preview {
    ContentView()
}
