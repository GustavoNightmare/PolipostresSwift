//
//  RegisterView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var vm = RegisterViewModel()

    @FocusState private var focusedField: Field?
    enum Field { case name, email, password, confirm }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Título de App
                    Text("PoliPostres")
                        .font(.title2).bold()
                        .foregroundColor(AppColors.text)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 24)

                    // Título de pantalla
                    Text("Crear cuenta")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(AppColors.text)
                        .padding(.top, 40)

                    // Nombre
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Nombre", text: $vm.name)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled(true)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .name)
                            .onSubmit { focusedField = .email }
                            .fieldStyle()
                    }

                    // Correo
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Correo", text: $vm.email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .email)
                            .onSubmit { focusedField = .password }
                            .fieldStyle()
                    }

                    // Contraseña
                    VStack(alignment: .leading, spacing: 8) {
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
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .confirm }

                            Button {
                                vm.showPassword.toggle()
                            } label: {
                                Image(systemName: vm.showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(AppColors.hint)
                            }
                        }
                        .fieldStyle()
                    }

                    // Confirmar contraseña
                    VStack(alignment: .leading, spacing: 8) {
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
                            .focused($focusedField, equals: .confirm)
                            .submitLabel(.done)

                            Button {
                                vm.showConfirmPassword.toggle()
                            } label: {
                                Image(systemName: vm.showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(AppColors.hint)
                            }
                        }
                        .fieldStyle()
                    }

                    // Error
                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }

                    // Botón Registrarme
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
                    .opacity(vm.isSaving ? 0.6 : 1.0)
                    .padding(.top, 8)

                    // Enlace a login
                    HStack {
                        Text("¿Ya tienes cuenta?")
                            .foregroundColor(AppColors.hint)
                        NavigationLink("Inicia sesión") {
                            LoginView()
                        }
                        .foregroundColor(AppColors.text)
                        .underline()
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .alert("¡Registro exitoso!", isPresented: $vm.didRegister) {
            Button("OK") { }
        } message: {
            Text("Tus datos se guardaron localmente en el dispositivo.")
        }
    }
}

#Preview {
    NavigationStack { RegisterView() }
    
}
