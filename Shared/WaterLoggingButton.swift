//
//  WaterLoggingButton.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct WaterLoggingButton: View {
    enum Action {
        case intent(any AppIntent)
        case closure((Double) -> Void)
    }

    @Binding var amount: Double
    @State private var animation = false
    @State private var failAnimation = false
    var action: Action

    var body: some View {
        VStack {
            switch action {
            case .closure(let closure):
                Button {
                    if amount <= 0 {
                        failAnimation.toggle()
                        return
                    } else {
                        animation.toggle()
                    }
                    closure(amount)
                    WidgetCenter.shared.reloadAllTimelines()
                } label: {
                    Label(
                        "Log \(Int(amount))\u{202f}ml of water",
                        systemImage: "drop.fill"
                    )
                    .padding(20)
                    .font(.largeTitle)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.white)
                    .background(.blue, in: .circle)
                    .symbolEffect(.wiggle.down, value: animation)
                    .symbolEffect(.bounce, value: animation)
                    .symbolEffect(.wiggle.right, value: failAnimation)
                }
            case .intent(let intent):
                Button(intent: intent) {
                    Label(
                        "Log \(Int(amount))\u{202f}ml of water",
                        systemImage: "drop.fill"
                    )
                    .padding(20)
                    .font(.largeTitle)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.white)
                    .background(.blue, in: .circle)
                    .symbolEffect(.wiggle.down, value: animation)
                    .symbolEffect(.bounce, value: animation)
                    .symbolEffect(.wiggle.right, value: failAnimation)
                }
                .simultaneousGesture(
                    TapGesture().onEnded {
                        if amount <= 0 {
                            failAnimation.toggle()
                            return
                        } else {
                            animation.toggle()
                        }
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                )
            }
            Text("Tap to log water")
                .font(.footnote)
        }
    }
}

#Preview {
    WaterLoggingButton(amount: .constant(200), action: .closure({ print($0) }))
}
