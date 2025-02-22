//
//  Item.swift
//  ifunlearn
//
//  Created by Abdulmenaf Altintas on 2025-02-21.
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
