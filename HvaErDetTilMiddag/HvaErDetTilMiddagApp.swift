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
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
