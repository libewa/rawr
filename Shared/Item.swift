//
//  Item.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import Foundation
import SwiftData

@Model
final class Item {
  var timestamp: Date
  var amount: Double
  var id: UUID = UUID()

  static var isInTodayPredicate: Predicate<Item> {
    let startOfToday = Calendar.current.startOfDay(for: Date())
    let endOfToday = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!
    return #Predicate<Item> {
      return $0.timestamp >= startOfToday && $0.timestamp < endOfToday
    }
  }

  init(timestamp: Date) {
    self.timestamp = timestamp
    self.amount = 200
  }
  init(timestamp: Date, amount: Double) {
    self.timestamp = timestamp
    self.amount = amount
  }
  init(timestamp: Date, amount: Double, id: UUID) {
    self.timestamp = timestamp
    self.amount = amount
    self.id = id
  }
}
