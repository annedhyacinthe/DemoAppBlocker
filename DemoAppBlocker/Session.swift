//
//  Session.swift
//  DemoAppBlocker
//
//  Created by Anne Hyacinthe on 1/28/26.
//

import Foundation
import SwiftData
import FamilyControls

@Model
final class Session {
    var selectedApps: FamilyActivitySelection
    var id: UUID
    var name: String
    var isBlocked: Bool
    init(selectedApps: FamilyActivitySelection, id: UUID, name: String, isBlocked: Bool) {
        self.selectedApps = selectedApps
        self.id = id
        self.name = name
        self.isBlocked = isBlocked
    }
}
