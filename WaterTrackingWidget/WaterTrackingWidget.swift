//
//  WaterTrackingWidget.swift
//  WaterTrackingWidget
//
//  Created by Linus Warnatz on 18.06.25.
//

import SwiftData
import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(
                byAdding: .hour,
                value: hourOffset,
                to: currentDate
            )!
            let entry = SimpleEntry(
                date: entryDate,
                configuration: configuration
            )
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct WaterTrackingWidgetView: View {
    var entry: Provider.Entry
    @Query private var items: [Item]

    private var totalToday: Double {
        items.filter({ Calendar.current.isDateInToday($0.timestamp) })
            .compactMap({ $0.amount }).reduce(0, +)
    }

    var body: some View {
        VStack {
            Text("\(Int(totalToday)) ml today")

            Button(
                intent: LogWaterAppIntent(amount: entry.configuration.$amount)
            ) {
                WaterLoggingButtonContent(amount: entry.configuration.amount)
            }
        }
    }
}

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
            provider: Provider()
        ) { entry in
            WaterTrackingWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(sharedModelContainer)
        }
        .supportedFamilies([.systemSmall, .accessoryInline])
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

//TODO: Lock screen widgets are clipped off at the bottom
