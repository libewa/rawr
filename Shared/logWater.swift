//
//  logWater.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import HealthKit
import SwiftData
import SwiftUI

func logWater(
    amount: Double,
    notifications: [Notification],
    totalToday: Double,
    modelContext context: ModelContext
) {
    print("Logging \(amount)ml of water")
    withAnimation {
        let inOneHour = Calendar.current.date(
            byAdding: DateComponents(hour: 1),
            to: Date()
        )!
        let inOneAndAHalfHours = Calendar.current.date(
            byAdding: DateComponents(hour: 1, minute: 30),
            to: Date()
        )!
        while notifications.sorted().first?.timestamp ?? Date.distantFuture
            <= inOneAndAHalfHours
        {
            print(
                "Deleted notification with timestamp \(notifications.sorted()[0].timestamp)"
            )
            context.delete(notifications.sorted()[0])
        }
        createNotification(
            timestamp: inOneHour,
            pastIntake: totalToday,
            modelContext: context
        )
        Task {
            if HKHealthStore.isHealthDataAvailable()
                && UserDefaults.standard.bool(forKey: "syncHealthData")
            {
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
                print("Logged water without HealthKit integration")
                try context.save()
            }
        }
    }
}
