//
//  HvaErDetTilMiddagApp.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 01/04/2025.
//

import SwiftUI
import Firebase

@main
struct HvaErDetTilMiddagApp: App {
    @StateObject private var inventoryModel = InventoryModel()
    @StateObject private var shoppingModel = ShoppingModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(inventoryModel)
                .environmentObject(shoppingModel)
        }
    }
}
