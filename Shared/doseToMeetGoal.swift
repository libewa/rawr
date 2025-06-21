//
//  doseToMeetGoal.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import Foundation

func doseToMeetGoal(
  goal: Double,
  amountToday: Double,
  timestamp: Date,
  endOfDay: Date
) -> Double {
  let hoursToEndOfDay = endOfDay.timeIntervalSince(timestamp) / 3600
  let remainingGoal = goal - amountToday
  guard remainingGoal > 0 else { return 0.0 }
  let dosePerHour = remainingGoal / hoursToEndOfDay
  return dosePerHour
}
