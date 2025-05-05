import SwiftUI

struct FilterPopupView: View {
    @Binding var selectedCategory: String?
    @Binding var showExpiringSoonOnly: Bool
    @Binding var sortByExpiration: Bool
    var onClose: () -> Void

    let categories = ["Alle", "Grønnsaker", "Frukt", "Meieri", "Kjøtt", "Fisk", "Pålegg", "Bakst", "Annet"]

    var body: some View {
        VStack(spacing: 16) {
            Text("Filtrer og sorter")
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundColor(Color("PrimaryGreen"))

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Text("Kategori")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("DeepGreen"))
                    .fontDesign(.rounded)

                Picker("Kategori", selection: Binding(
                    get: { selectedCategory ?? "Alle" },
                    set: { selectedCategory = $0 == "Alle" ? nil : $0 }
                )) {
                    ForEach(categories, id: \.self) {
                        Text($0).fontDesign(.rounded)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(Color("PrimaryGreen"))
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Andre filtre")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("DeepGreen"))
                    .fontDesign(.rounded)

                Toggle("Vis varer som går ut snart", isOn: $showExpiringSoonOnly)
                    .toggleStyle(SwitchToggleStyle(tint: Color("PrimaryGreen")))
                    .fontDesign(.rounded)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Sorter etter")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("DeepGreen"))
                    .fontDesign(.rounded)

                Picker("Sortering", selection: $sortByExpiration) {
                    Text("Utløpsdato").tag(true)
                    Text("Navn").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .accentColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)
            }

            Divider()

            Button(action: onClose) {
                Text("Ferdig")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
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