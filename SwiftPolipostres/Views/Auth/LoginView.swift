//
//  LoginView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @StateObject private var vm = LoginViewModel()

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

                    Text("Bienvenido a PoliPostres")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(AppColors.text)
                        .padding(.top, 24)

                    TextField("Correo", text: $vm.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                        .fieldStyle()

                    HStack {
                        SecureField("Contraseña", text: $vm.password)
                        Button {
                            // nada (solo icono para simular)
                        } label: {
                            Image(systemName: "eye")
                                .foregroundColor(AppColors.hint)
                        }
                    }
                    .fieldStyle()

                    if let err = vm.errorMessage {
                        Text(err).foregroundColor(.red).font(.footnote)
                    }

                    Button {
                        vm.login { user in auth.signIn(user) }
                    } label: {
                        HStack { Image(systemName: "arrow.right.to.line"); Text("Ingresar").bold() }
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(AppColors.pink)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }

                    HStack {
                        Text("¿No tienes cuenta?")
                            .foregroundColor(AppColors.hint)
                        NavigationLink("Regístrate") { RegisterView() }
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
    }
}

#Preview { NavigationStack { LoginView().environmentObject(AuthViewModel()) } }

