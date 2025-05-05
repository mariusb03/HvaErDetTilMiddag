
import SwiftUI

struct InventoryView: View {
    @State private var ingredients: [String] = []
    @State private var newIngredient: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("🧺 My Pantry")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                List {
                    ForEach(ingredients, id: \.self) { item in
                        Text(item)
                    }
                }

                HStack {
                    TextField("Add ingredient...", text: $newIngredient)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        if !newIngredient.trimmingCharacters(in: .whitespaces).isEmpty {
                            ingredients.append(newIngredient)
                            newIngredient = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    InventoryView()
}
