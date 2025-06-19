//
//  Notification.swift
//  rawr
//
//  Created by Linus Warnatz on 18.06.25.
//

import Foundation
import SwiftData

@Model class Notification: Identifiable, Comparable {
    static func < (lhs: Notification, rhs: Notification) -> Bool {
        lhs.timestamp < rhs.timestamp
    }

    var id: UUID = UUID()
    var timestamp: Date

    init(id: UUID, timestamp: Date) {
        self.id = id
        self.timestamp = timestamp
    }
    convenience init(timestamp: Date) {
        self.init(id: UUID(), timestamp: timestamp)
    }
}
