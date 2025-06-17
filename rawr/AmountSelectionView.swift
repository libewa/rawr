//
//  AmountSelectionView.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import SwiftUI

struct AmountSelectionView: View {
    @Binding var amount: Double

    private func changeAmount(by diff: Double) {
            amount = ((amount + diff) / 10).rounded() * 10
            if amount > maxAmount {
                amount = maxAmount
            } else if amount < 0 {
                amount = 0
            }
    }

    let maxAmount: Double = 2000.0
    var body: some View {
        VStack {
            Button {
                changeAmount(by: 10)
            } label: {
                Label("Increase", systemImage: "plus")
                    .labelStyle(.iconOnly)
            }
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
            .gesture(
                DragGesture()
                    .onChanged { v in
                        changeAmount(by: -v.translation.height / 5)
                    }
            )
            .padding(.vertical, 5)
            .padding(.bottom)
            Button {
                changeAmount(by: -10)
            } label: {
                Label("Decrease", systemImage: "minus")
                    .labelStyle(.iconOnly)
            }
        }
        .frame(width: 80, height: 200)
    }
}

#Preview {
    @Previewable @State var amount = 1500.0
    AmountSelectionView(amount: $amount)
}
