//
//  RegisterView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//
import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var auth: AuthViewModel
    @StateObject private var vm = RegisterViewModel()
    @FocusState private var focused: Field?
    enum Field { case name, email, pass, confirm }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("PoliPostres")
                        .font(.title2).bold()
                        .foregroundColor(AppColors.text)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 24)

                    Text("Crear cuenta")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(AppColors.text)
                        .padding(.top, 40)

                    TextField("Nombre", text: $vm.name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(true)
                        .submitLabel(.next)
                        .focused($focused, equals: .name)
                        .onSubmit { focused = .email }
                        .fieldStyle()

                    TextField("Correo", text: $vm.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                        .submitLabel(.next)
                        .focused($focused, equals: .email)
                        .onSubmit { focused = .pass }
                        .fieldStyle()

                    HStack {
                        Group {
                            if vm.showPassword {
                                TextField("Contraseña", text: $vm.password)
                            } else {
                                SecureField("Contraseña", text: $vm.password)
                            }
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .focused($focused, equals: .pass)
                        .submitLabel(.next)

                        Button { vm.showPassword.toggle() } label: {
                            Image(systemName: vm.showPassword ? "eye.slash" : "eye")
                                .foregroundColor(AppColors.hint)
                        }
                    }
                    .fieldStyle()

                    HStack {
                        Group {
                            if vm.showConfirmPassword {
                                TextField("Confirmar contraseña", text: $vm.confirmPassword)
                            } else {
                                SecureField("Confirmar contraseña", text: $vm.confirmPassword)
                            }
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .focused($focused, equals: .confirm)

                        Button { vm.showConfirmPassword.toggle() } label: {
                            Image(systemName: vm.showConfirmPassword ? "eye.slash" : "eye")
                                .foregroundColor(AppColors.hint)
                        }
                    }
                    .fieldStyle()

                    if let err = vm.errorMessage {
                        Text(err).foregroundColor(.red).font(.footnote)
                    }

                    Button {
                        vm.register()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "square.grid.2x2.fill")
                            Text("Registrarme").bold()
                        }
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(AppColors.pink)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                    }
                    .disabled(vm.isSaving)
                    .opacity(vm.isSaving ? 0.6 : 1)

                    HStack {
                        Text("¿Ya tienes cuenta?")
                            .foregroundColor(AppColors.hint)
                        NavigationLink("Inicia sesión") { LoginView() }
                            .foregroundColor(AppColors.text)
                            .underline()
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .alert("¡Registro exitoso!", isPresented: $vm.didRegister) {
            Button("OK") {
                // Tip: podrías iniciar sesión automática
            }
        } message: { Text("Tu usuario fue guardado localmente.") }
    }
}

#Preview { NavigationStack { RegisterView().environmentObject(AuthViewModel()) } }
