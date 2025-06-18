//
//  AmountSelectionView.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import SwiftUI

struct TargetProgressView: View {
    let amount: Double
    let maxAmount: Double = 2000.0
    
    var body: some View {
        VStack {
            GeometryReader { g in
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.quinary)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: g.size.height / maxAmount * amount)
                        .offset(
                            y: g.size.height / 2
                                - (g.size.height / maxAmount * amount) / 2
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
