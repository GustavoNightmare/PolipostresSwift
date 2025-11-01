import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        ZStack {
            // Fondo oscuro similar a la imagen
            Color(.sRGB, red: 22/255, green: 9/255, blue: 12/255, opacity: 1)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer().frame(height: 40)

                // Título superior centrado
                Text("Bienvenida a Polipostres")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.sRGB, red: 255/255, green: 196/255, blue: 207/255, opacity: 1))
                    .padding(.top, 8)

                Spacer().frame(height: 40)

                VStack(spacing: 16) {
                    // Campo correo
                    TextField("Correo", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.sRGB, red: 190/255, green: 170/255, blue: 175/255, opacity: 0.5), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)

                    // Campo contraseña con botón ojo
                    ZStack {
                        if viewModel.isPasswordVisible {
                            TextField("Contraseña", text: $viewModel.password)
                                .autocapitalization(.none)
                        } else {
                            SecureField("Contraseña", text: $viewModel.password)
                        }
                    }
                    .padding()
                    .background(Color.clear)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: { viewModel.isPasswordVisible.toggle() }) {
                                Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(Color(.sRGB, red: 190/255, green: 170/255, blue: 175/255, opacity: 0.9))
                                    .padding(.trailing, 28)
                            }
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.sRGB, red: 190/255, green: 170/255, blue: 175/255, opacity: 0.5), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                }

                // Botón Ingresar
                Button(action: {
                    viewModel.login()
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                        Text("Ingresar")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.sRGB, red: 255/255, green: 179/255, blue: 191/255, opacity: 1))
                    )
                    .foregroundColor(Color(.sRGB, red: 50/255, green: 20/255, blue: 20/255, opacity: 1))
                    .padding(.horizontal, 24)
                }
                .padding(.top, 6)

                // Link para registrarse
                Button(action: {
                    // aquí enrutar a la pantalla de registro
                }) {
                    Text("¿No tienes cuenta? Regístrate")
                        .foregroundColor(Color(.sRGB, red: 255/255, green: 179/255, blue: 191/255, opacity: 1))
                }
                .padding(.top, 12)

                Spacer()
            } // VStack
        } // ZStack
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(userRepository: UserRepository.shared))
            .previewDevice("iPhone 13")
    }
}

