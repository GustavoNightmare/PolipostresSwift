import SwiftUI

struct SellView: View {
    @EnvironmentObject var auth: AuthViewModel          // 👈
    @StateObject private var vm = SellViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("PoliPostres")
                        .font(.headline)
                        .foregroundColor(AppColors.text)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)

                    Text("Vender postres")
                        .font(.largeTitle).bold()
                        .foregroundColor(AppColors.text)
                        .padding(.bottom, 6)

                    ForEach(vm.items) { item in
                        PostreRowView(item: item, onSell: { vm.sellOne(item) })
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
            }

            if let msg = vm.toastMessage {
                ToastView(message: msg)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 22)
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
        .onAppear { vm.load() }
    }
}

#Preview { NavigationStack { SellView().environmentObject(AuthViewModel()) } }
