//
//  Item.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 01/04/2025.
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
