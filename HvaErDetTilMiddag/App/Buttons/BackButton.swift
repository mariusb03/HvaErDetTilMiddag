//
//  BackButton.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            ZStack {
                Image(systemName: "arrow.left") // Back icon
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.red)
                    .padding()
                    .cornerRadius(15)
                    .shadow(color: .red, radius: 5)
                    
                Image(systemName: "arrow.left") // Back icon
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .cornerRadius(15)
                    .shadow(color: .red, radius: 5)
            }
        }
    }
}
