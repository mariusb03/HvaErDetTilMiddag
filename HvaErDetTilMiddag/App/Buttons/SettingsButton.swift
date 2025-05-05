//
//  SettingsButton.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//

import SwiftUI

struct SettingsButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: "gearshape.fill") // Settings icon
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.red)
                    .padding()
                    .cornerRadius(15)
                    .shadow(color: .red, radius: 5)
                
                Image(systemName: "gearshape.fill") // Settings icon
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .cornerRadius(15)
                    .shadow(color: .red, radius: 5)
                    .shadow(radius: 5)
            }
        }
    }
}
