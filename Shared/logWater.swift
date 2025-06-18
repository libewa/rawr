//
//  logWater.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import SwiftUI
import SwiftData
import HealthKit

func logWater(amount: Double, notifications: [Notification], totalToday: Double, modelContext context: ModelContext) {
    withAnimation {
        while notifications.sorted().first?.timestamp ?? Date.distantFuture < Date() {
            context.delete(notifications.sorted()[0])
        }
        if let nextNotification = notifications.sorted().first {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removePendingNotificationRequests(
                withIdentifiers: [nextNotification.id.uuidString])
        }
        let inOneHour = Calendar.current.date(
            byAdding: DateComponents(hour: 1),
            to: Date()
        )!
        if notifications.sorted().first?.timestamp ?? Date.distantFuture > inOneHour {
            createNotification(timestamp: inOneHour, pastIntake: totalToday, modelContext: context)
        }
        Task {
            if HKHealthStore.isHealthDataAvailable() && UserDefaults.standard.bool(forKey: "syncHealthData") {
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
