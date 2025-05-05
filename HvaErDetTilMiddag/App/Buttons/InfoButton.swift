//
//  InfoButton.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//

import SwiftUI

struct InfoButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            
            Image("InfoButton") // Settings icon
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.white)
                .padding()
                .cornerRadius(15)
                .shadow(color: .red, radius: 5)
            
        }
    }
}

