import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var auth: AuthViewModel          // 👈
    private let repo: InventoryRepository = FileInventoryRepository()
    @State private var items: [Postre] = []

    var totalSold: Int { items.reduce(0) { $0 + $1.sold } }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("PoliPostres")
                        .font(.headline)
                        .foregroundColor(AppColors.text)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Resumen de ventas").font(.headline).foregroundColor(AppColors.text)
                        Text("Total vendido: \(totalSold)")
                            .foregroundColor(AppColors.text)
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.surface))

                    Text("Por postre").font(.headline).foregroundColor(AppColors.text)

                    ForEach(items.sorted(by: { $0.sold > $1.sold })) { p in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(p.nombre).foregroundColor(AppColors.text).font(.headline)
                                Text("Stock actual: \(p.stock)").foregroundColor(AppColors.hint).font(.subheadline)
                            }
                            Spacer()
                            Text("Vendidos: \(p.sold)").foregroundColor(AppColors.text)
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.surface))
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Cerrar sesión (izquierda)
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    auth.signOut()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Salir")
                    }
                    .foregroundColor(AppColors.text)
                }
            }
            // Créditos (derecha)
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: CreditsView()) {
                    Image(systemName: "info.circle").foregroundColor(AppColors.text)
                }
            }
        }
        .onAppear { items = repo.getAll() }
        .onReceive(NotificationCenter.default.publisher(for: .inventoryDidChange)) { _ in
            items = repo.getAll()
        }
    }
}

#Preview { NavigationStack { MetricsView().environmentObject(AuthViewModel()) } }
