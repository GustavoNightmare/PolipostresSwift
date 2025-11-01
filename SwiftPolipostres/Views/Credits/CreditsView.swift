import SwiftUI

struct CreditsView: View {
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text("Créditos")
                        .font(.largeTitle).bold()
                        .foregroundColor(AppColors.text)
                        .padding(.top, 20)

                    // 👇 Imagen desde Assets con el nombre "foto"
                    Image("foto")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 8)
                        .padding(.top, 6)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Universidad del Cauca")
                        Text("Departamento de Telemática")
                        Text("Asignatura: Electiva Desarrollo de Aplicaciones Móviles")
                    }
                    .foregroundColor(AppColors.hint)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Estudiantes")
                            .font(.title3).bold()
                            .foregroundColor(AppColors.text)
                        creditItem(name: "Gustavo Sandoval")
                        creditItem(name: "Farid Carvajal")
                        creditItem(name: "Fabio Valencia")
                    }
                    .padding(.horizontal, 12)

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Créditos")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func creditItem(name: String) -> some View {
        HStack {
            Image(systemName: "person.fill")
            Text(name).bold().lineLimit(1)
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.surface))
        .foregroundColor(AppColors.text)
    }
}

#Preview { NavigationStack { CreditsView() } }

