//
//  WaterTrackingWidgetView.swift
//  rawr
//
//  Created by Linus Warnatz on 21.06.25.
//

import SwiftUI
import WidgetKit
import SwiftData

struct WaterTrackingWidgetView: View {
  var entry: TimelineProvider.Entry
  @Query private var items: [Item]
  @Environment(\.widgetFamily) var widgetFamily
  @AppStorage("dailyGoal") var maxAmount: Double = 2000

  private var totalToday: Double {
    items.filter({ Calendar.current.isDateInToday($0.timestamp) })
      .compactMap({ $0.amount }).reduce(0, +)
  }

  var body: some View {
    VStack {
      switch widgetFamily {
        case .accessoryCircular:
          WaterLoggingButton(
            amount: .constant(entry.configuration.amount),
            hintStyle: .none,
            action: .intent(
              LogWaterAppIntent(amount: entry.configuration.$amount)
            )
          )
        case .accessoryRectangular:
          HStack {
            WaterLoggingButton(
              amount: .constant(entry.configuration.amount),
              hintStyle: .none,
              action: .intent(
                LogWaterAppIntent(amount: entry.configuration.$amount)
              )
            )
            .scaleEffect(0.9)
            ProgressView(value: totalToday, total: maxAmount) {
              Text("\(Int(totalToday)) ml today")
            }
          }
        /*case .accessoryCorner:
          WaterLoggingButton(
            amount: .constant(entry.configuration.amount),
            hintStyle: .none,
            action: .intent(
              LogWaterAppIntent(amount: entry.configuration.$amount)
            )
          )
          .scaleEffect(0.9)
          ProgressView(value: totalToday, total: maxAmount) {
            Text("\(Int(totalToday)) ml today")
          }*/
        default:
          Text("\(Int(totalToday)) ml today")
          WaterLoggingButton(
            amount: .constant(entry.configuration.amount),
            hintStyle: .simple,
            action: .intent(
              LogWaterAppIntent(amount: entry.configuration.$amount)
            )
          )
      }
    }
  }
}
