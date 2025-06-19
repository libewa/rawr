//
//  ContentView.swift
//  rawr-watch Watch App
//
//  Created by Linus Warnatz on 19.06.25.
//

import SwiftData
import SwiftUI
import HealthKit

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query var items: [Item]
    @State private var amount: Double = 200
    @State private var syncHealthData = UserDefaults.standard.bool(
        forKey: "syncHealthData"
    )
    
    let healthTypes: Set = [
        HKQuantityType(.dietaryWater)
    ]
    
    var maxAmount: Double {
        let goal = UserDefaults.standard.double(forKey: "dailyGoal")
        if goal > 0 {
            return goal
        } else {
            UserDefaults.standard.set(2000, forKey: "dailyGoal")
            return 2000  // Default goal if not set
        }
    }
    private var totalToday: Double {
        let total = items.filter({
            Calendar.current.isDateInToday($0.timestamp)
        }).compactMap({ $0.amount }).reduce(0, +)
        print("Total today: \(total)ml")
        return total
    }

    var body: some View {
        VStack {
            Text("\(Int(totalToday))\u{202f}ml / \(Int(maxAmount))\u{202f}ml today")
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
            .onChange(of: syncHealthData, initial: true) {
                if syncHealthData {
                    Task {
                        try await enableAndSyncHealthIntegration(
                            types: healthTypes
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
