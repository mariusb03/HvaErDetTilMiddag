import SwiftUI

struct AddRecipePopupView: View {
    @State private var title: String = ""
    @State private var ingredients: String = ""
    @State private var instructions: String = ""

    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Ny Oppskrift")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)

            TextField("Navn på oppskrift", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .fontDesign(.rounded)

            TextEditor(text: $ingredients)
                .frame(height: 80)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                .background(Color.white)
                .cornerRadius(8)
                .fontDesign(.rounded)
                .padding(.top, 4)
                .overlay(
                    Text("Ingredienser")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(4),
                    alignment: .topLeading
                )

            TextEditor(text: $instructions)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                .background(Color.white)
                .cornerRadius(8)
                .fontDesign(.rounded)
                .padding(.top, 4)
                .overlay(
                    Text("Fremgangsmåte")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(4),
                    alignment: .topLeading
                )

            HStack {
                Button("Avbryt") {
                    onClose()
                }
                .foregroundColor(.red)
                .fontDesign(.rounded)

                Spacer()

                Button("Lagre") {
                    // TODO: Save recipe logic
                    onClose()
                }
                .foregroundColor(Color("PrimaryGreen"))
                .fontWeight(.bold)
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