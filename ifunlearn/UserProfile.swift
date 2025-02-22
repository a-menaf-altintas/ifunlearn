//
//  UserProfile.swift
//  ifunlearn
//
//  Created by Abdulmenaf Altintas on 2025-02-21.
//

import Foundation
import SwiftData

@Model
class UserProfile {
    var id: UUID
    var name: String
    var creationDate: Date

    init(id: UUID = UUID(), name: String, creationDate: Date = Date()) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
    }
}
