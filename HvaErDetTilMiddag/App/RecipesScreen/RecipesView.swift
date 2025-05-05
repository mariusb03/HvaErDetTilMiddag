import SwiftUI

struct RecipesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("🍳 Recipes")
                    .font(.largeTitle)
                    .padding()

                Text("Here you'll see suggested recipes based on your pantry.")
                    .padding()
                    .foregroundColor(.gray)
            }
        }
    }
}