//
//  WaterLoggingButton.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import SwiftData
import SwiftUI
import WidgetKit

struct WaterLoggingButton: View {
    @Binding var amount: Double
    @State private var animation = false
    @State private var failAnimation = false
    var action: (_ amount: Double) -> Void

    var body: some View {
        VStack {
            Button {
                if amount <= 0 {
                    failAnimation.toggle()
                    return
                } else {
                    animation.toggle()
                }
                action(amount)
                WidgetCenter.shared.reloadAllTimelines()
            } label: {
                WaterLoggingButtonContent(
                    amount: amount,
                    animation: animation,
                    failAnimation: failAnimation
                )
            }
            Text("Tap to log water")
                .font(.footnote)
        }
    }
}

#Preview {
    WaterLoggingButton(amount: .constant(200)) {
        print($0)
    }
}
