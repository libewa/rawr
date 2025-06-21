//
//  AmountSelectionView.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import SwiftUI

struct TargetProgressView: View {
  @AppStorage("dailyGoal") var maxAmount: Double = 2000
  let amount: Double

  var body: some View {
    VStack {
      GeometryReader { geometry in
        let proportionalAmount =
          geometry.size.height / maxAmount
          * (amount > maxAmount ? maxAmount : amount)
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.quinary)
          RoundedRectangle(cornerRadius: 10)
            .frame(height: proportionalAmount)
            .offset(
              y: geometry.size.height / 2
                - proportionalAmount / 2
            )
            .foregroundStyle(.blue.mix(with: .white, by: 0.15))
          Text("\(Int(amount))\u{202f}ml")
            .padding(5)
        }
      }
      .padding(.vertical, 5)
      .frame(width: 80, height: 200)
    }
    .buttonBorderShape(.circle)
    .buttonStyle(.bordered)
  }
}

#Preview {
  var amount = 1500.0
  TargetProgressView(amount: amount)
}
