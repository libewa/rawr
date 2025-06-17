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
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
