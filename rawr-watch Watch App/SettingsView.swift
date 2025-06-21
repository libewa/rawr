//
//  SettingsView.swift
//  rawr
//
//  Created by Linus Warnatz on 20.06.25.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage("dailyGoal") var dailyGoal: Double = 2000

  var body: some View {
    Form {
      Text("Daily goal: \(Int(dailyGoal))\u{202f}ml")
      Stepper(value: $dailyGoal, in: 100...10000, step: 10) {}
    }
  }
}

#Preview {
  SettingsView()
}
