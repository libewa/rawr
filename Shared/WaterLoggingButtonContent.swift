//
//  WaterLoggingButtonContent.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import SwiftUI

struct WaterLoggingButtonContent: View {
    let amount: Double
    let animation: Bool
    let failAnimation: Bool
    init(amount: Double, animation: Bool, failAnimation: Bool) {
        self.amount = amount
        self.animation = animation
        self.failAnimation = failAnimation
    }
    init(amount: Double) {
        self.amount = amount
        self.animation = false
        self.failAnimation = false
    }
    var body: some View {
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
}

#Preview {
    WaterLoggingButtonContent(
        amount: 200,
        animation: false,
        failAnimation: false
    )
}
