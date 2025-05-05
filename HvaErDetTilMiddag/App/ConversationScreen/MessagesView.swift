//
//  MessagesView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//


import SwiftUI

struct MessagesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("💬 Group Chat")
                    .font(.largeTitle)
                    .padding()

                Text("Group messages and recipe sharing go here.")
                    .padding()
                    .foregroundColor(.gray)
            }
        }
    }
}