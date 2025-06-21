//
//  WaterTrackingWidget.swift
//  WaterTrackingWidget
//
//  Created by Linus Warnatz on 18.06.25.
//

import SwiftData
import SwiftUI
import WidgetKit

struct WaterTrackingWidget: Widget {
  var sharedModelContainer: ModelContainer = {
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
  let kind: String = "WaterTrackingWidget"
  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind,
      intent: ConfigurationAppIntent.self,
      provider: TimelineProvider()
    ) { entry in
      WaterTrackingWidgetView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
        .modelContainer(sharedModelContainer)
    }
    .supportedFamilies([.systemSmall, .accessoryInline, .accessoryCircular, .accessoryRectangular])
  }
}

extension ConfigurationAppIntent {
  fileprivate static var glass: ConfigurationAppIntent {
    let intent = ConfigurationAppIntent()
    intent.amount = 200
    return intent
  }
  fileprivate static var portableBottle: ConfigurationAppIntent {
    let intent = ConfigurationAppIntent()
    intent.amount = 500
    return intent
  }
}

#Preview(as: .systemSmall) {
  WaterTrackingWidget()
} timeline: {
  SimpleEntry(date: .now, configuration: .glass)
  SimpleEntry(date: .now, configuration: .portableBottle)
}

#Preview(as: .accessoryInline) {
  WaterTrackingWidget()
} timeline: {
  SimpleEntry(date: .now, configuration: .glass)
  SimpleEntry(date: .now, configuration: .portableBottle)
}

#Preview(as: .accessoryCircular) {
    WaterTrackingWidget()
} timeline: {
  SimpleEntry(date: .now, configuration: .glass)
  SimpleEntry(date: .now, configuration: .portableBottle)
}

#Preview(as: .accessoryRectangular) {
  WaterTrackingWidget()
} timeline: {
  SimpleEntry(date: .now, configuration: .glass)
  SimpleEntry(date: .now, configuration: .portableBottle)
}

