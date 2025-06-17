//
//  WaterLoggingButton.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import SwiftUI

struct WaterLoggingButton: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var amount: Double
    @State private var animation = false
    @State private var failAnimation = false

    var body: some View {
        VStack {
            Button {} label: {
                Label("Log \(Int(amount))\u{202f}ml of water", systemImage: "drop.fill")
                    .padding(20)
                    .font(.largeTitle)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.white)
                    .background(.blue, in: .circle)
                    .symbolEffect(.wiggle.down, value: animation)
                    .symbolEffect(.bounce, value: animation)
                    .symbolEffect(.wiggle.right, value: failAnimation)
            }
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                if amount <= 0 {
                    failAnimation.toggle()
                } else {
                    animation.toggle()
                }
                logWater(amount: amount)
            }, name: "Activate")
            Text("Hold to log water")
                .font(.footnote)
        }
    }
    private func logWater(amount: Double) {
        withAnimation {
            let item = Item(timestamp: Date(), amount: amount)
            modelContext.insert(item)
            self.amount = 0
        }
    }
}

#Preview {
    WaterLoggingButton(amount: .constant(200))
}
