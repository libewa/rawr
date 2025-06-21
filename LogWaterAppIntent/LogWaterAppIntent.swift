//
//  LogWaterAppIntent.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import AppIntents
import HealthKit
import SwiftData
import SwiftUI
import WidgetKit

struct LogWaterAppIntent: AppIntent {
  static var title: LocalizedStringResource = "Log Water"
  static var description: IntentDescription =
    "Log a specific amount of water."
  static var openAppWhenRun = false

  @Parameter(
    title: "Amount",
    description: "The amount of water to log.",
    default: 200.0,
    controlStyle: .field
  )
  var amount: Double

  @Query var notifications: [Notification]
  @Query private var items: [Item]
  private var totalToday: Double {
    return items.filter({
      Calendar.current.isDateInToday($0.timestamp)
    }).compactMap({ $0.amount }).reduce(0, +)
  }

  @MainActor func perform() async throws -> some IntentResult {
    let sharedModelContainer: ModelContainer = {
      let schema = Schema([
        Item.self
      ])
      let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false
      )

      do {
        return try ModelContainer(
          for: schema,
          configurations: [modelConfiguration]
        )
      } catch {
        fatalError("Could not create ModelContainer: \(error)")
      }
    }()

    let context = ModelContext(sharedModelContainer)

    try logWater(
      amount: amount,
      totalToday: totalToday,
      modelContext: context
    )
    return .result()
  }
}
