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
    @Query private var items: [Item]
    @State var amount = 200.0
    @State private var isDeleting = false
    @State private var isProcessing = false
    @State private var syncHealthData = UserDefaults().bool(
        forKey: "syncHealthData"
    )

    private var totalToday: Double {
        return items.filter({
            Calendar.current.isDateInToday($0.timestamp)
        }).compactMap({ $0.amount }).reduce(0, +)
    }

    private func logWater(amount: Double) {
        withAnimation {
            self.amount = 0

            Task {
                if HKHealthStore.isHealthDataAvailable() && syncHealthData {
                    let healthStore = HKHealthStore()
                    let type = HKQuantityType(.dietaryWater)
                    let quantity = HKQuantity(
                        unit: .literUnit(with: .milli),
                        doubleValue: amount
                    )
                    let sample = HKQuantitySample(
                        type: type,
                        quantity: quantity,
                        start: Date(),
                        end: Date()
                    )
                    try await healthStore.save(sample)
                    let item = Item(
                        timestamp: Date(),
                        amount: amount,
                        id: sample.uuid
                    )
                    context.insert(item)
                } else {
                    let item = Item(timestamp: Date(), amount: amount)
                    context.insert(item)
                }
            }
        }
    }

    let healthTypes: Set = [
        HKQuantityType(.dietaryWater)
    ]

    var body: some View {
        VStack {
            Text("Welcome to Rawr!")
                .font(.title)
            Text("(Roughly Approximate Water Reminder)")
                .font(.subheadline)
            Divider()
            Toggle("Enable Health integration", isOn: $syncHealthData)
                .onChange(of: syncHealthData, initial: true) {
                    UserDefaults().set(syncHealthData, forKey: "syncHealthData")
                    if syncHealthData {
                        Task {
                            try await enableAndSyncHealthIntegration(
                                types: healthTypes
                            )
                        }
                    }
                }
            Spacer()
            //TODO: visualize drinking goal
            //TODO: create a notification for the user to drink water
            Text("You drank \(Int(totalToday)) ml today.")
            AmountSelectionView(amount: $amount)
            WaterLoggingButton(amount: $amount, action: logWater)
            Spacer()
            DeleteAllDataButton(
                isDeleting: $isDeleting,
                isProcessing: $isProcessing
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
