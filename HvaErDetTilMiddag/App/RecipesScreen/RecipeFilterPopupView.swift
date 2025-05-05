//
//  RecipeFilterPopupView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 05/05/2025.
//

import SwiftUI

struct RecipeFilterPopupView: View {
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Filtrer oppskrifter")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)

            Text("Denne funksjonen kommer snart!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .fontDesign(.rounded)

            Button(action: onClose) {
                Text("Lukk")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("GreenCard"))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 24)
    }
}
