//
//  createNotification.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import SwiftData
import UserNotifications
import Foundation


func createNotification(timestamp: Date, pastIntake totalToday: Double, modelContext context: ModelContext) {
    Task {
        try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound])
        let uuid = UUID()
        let dose = Int(
            doseToMeetGoal(
                goal: 2000.0,
                amountToday: totalToday,
                timestamp: timestamp,
                endOfDay: Calendar.current.date(
                    byAdding: .hour,
                    value: 20,
                    to: Calendar.current.startOfDay(for: Date())
                )!
            )
        )
        let content = UNMutableNotificationContent()
        content.title = "Drink Water"
        content.body =
        "Drink \(dose) ml of water now to still meet your daily goal!"
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [.hour, .minute, .second],
                from: timestamp
            ),
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: uuid.uuidString,
            content: content,
            trigger: trigger
        )
        let notificationCenter = UNUserNotificationCenter.current()
        try await notificationCenter.add(request)
        context.insert(Notification(id: uuid, timestamp: timestamp))
        print("Created notification for \(timestamp) with id \(uuid.uuidString)")
    }
    }
