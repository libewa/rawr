//
//  AppIntent.swift
//  WaterTrackingWidget
//
//  Created by Linus Warnatz on 18.06.25.
//

import AppIntents
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    @Parameter(
        title: "Amount",
        description: "The amount of water to log with the widget.",
        default: 200.0,
        controlStyle: .field
    )
    var amount: Double
}
