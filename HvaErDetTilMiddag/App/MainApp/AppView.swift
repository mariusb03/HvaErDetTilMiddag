//
//  AppView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//

import SwiftUI

enum Tab: Int {
    case recipes, shopping, inventory, messages, settings
}

struct AppView: View {
    @State private var selectedTab: Tab = .inventory

    init() {
        // Set global UITabBar appearance (optional)
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            MessagesView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                        .fontDesign(.rounded)
                }
                .tag(Tab.messages)

            ShoppingListView()
                .tabItem {
                    Label("Handleliste", systemImage: "cart")
                        .fontDesign(.rounded)
                }
                .tag(Tab.shopping)

            InventoryView()
                .tabItem {
                    Label("Dine Varer", systemImage: "basket")
                        .fontDesign(.rounded)
                }
                .tag(Tab.inventory)

            RecipesView()
                .tabItem {
                    Label("Oppskrifter", systemImage: "book.fill")
                        .fontDesign(.rounded)
                }
                .tag(Tab.recipes)

            SettingsView()
                .tabItem {
                    Label("Innstillinger", systemImage: "gearshape")
                        .fontDesign(.rounded)
                }
                .tag(Tab.settings)
        }
        .accentColor(Color("PrimaryGreen"))
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("LightGreen"), Color("Background")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    AppView()
}
