//
//  SettingsView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("🍳 Settings")
                    .font(.largeTitle)
                    .padding()

                Text("Here you'll see Settings.")
                    .padding()
                    .foregroundColor(.gray)
            }
        }
    }
}
