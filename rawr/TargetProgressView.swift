//
//  AmountSelectionView.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import SwiftUI

struct TargetProgressView: View {
    let amount: Double
    var maxAmount: Double {
        let goal = UserDefaults.standard.double(forKey: "dailyGoal")
        if goal > 0 {
            return goal
        } else {
            UserDefaults.standard.set(2000, forKey: "dailyGoal")
            return 2000  // Default goal if not set
        }
    }

    var body: some View {
        VStack {
            GeometryReader { g in
                let proportionalAmount =
                    g.size.height / maxAmount
                    * (amount > maxAmount ? maxAmount : amount)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.quinary)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: proportionalAmount)
                        .offset(
                            y: g.size.height / 2
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
