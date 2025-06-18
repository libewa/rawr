//
//  Item.swift
//  rawr
//
//  Created by Linus Warnatz on 17.06.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var amount: Double
    var id: UUID = UUID()

    init(timestamp: Date) {
        self.timestamp = timestamp
        self.amount = 200
    }
    init(timestamp: Date, amount: Double) {
        self.timestamp = timestamp
        self.amount = amount
    }
    init(timestamp: Date, amount: Double, id: UUID) {
        self.timestamp = timestamp
        self.amount = amount
        self.id = id
    }
}
