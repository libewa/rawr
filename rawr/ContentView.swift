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
    @Query private var notifications: [Notification]
    @State var amount = 200.0
    @State private var isDeleting = false
    @State private var isProcessing = false
    @State private var syncHealthData = UserDefaults.standard.bool(
        forKey: "syncHealthData"
    )

    private var totalToday: Double {
        return items.filter({
            Calendar.current.isDateInToday($0.timestamp)
        }).compactMap({ $0.amount }).reduce(0, +)
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
                TextField("Amount", value: $amount, formatter: NumberFormatter())
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                Text("ml")
            }
            .frame(width: 100)
            WaterLoggingButton(amount: $amount) {
                logWater(amount: $0, notifications: notifications, totalToday: totalToday, modelContext: context)
            }
            Spacer()
            Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                Label("Open App Settings", systemImage: "gearshape")
            }
            DeleteAllDataButton(
                isDeleting: $isDeleting,
                isProcessing: $isProcessing
            )
        }
        .onChange(of: syncHealthData, initial: true) {
            if syncHealthData {
                Task {
                    try await enableAndSyncHealthIntegration(
                        types: healthTypes
                    )
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
