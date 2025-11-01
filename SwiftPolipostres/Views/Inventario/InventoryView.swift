//
//  InventoryView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

swift
import SwiftUI

struct InventoryView: View {
    @StateObject private var vm = InventoryViewModel()

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

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Añadir postre")
                            .foregroundColor(AppColors.text)
                            .font(.headline)

                        TextField("Nombre del postre", text: $vm.name)
                            .autocorrectionDisabled(true)
                            .fieldStyle()

                        TextField("Stock inicial", text: $vm.stockText)
                            .keyboardType(.numberPad)
                            .fieldStyle()

                        HStack {
                            Button {
                                vm.addItem()
                            } label: {
                                HStack { Image(systemName: "plus"); Text("Guardar").bold() }
                                    .frame(maxWidth: 160, minHeight: 44)
                                    .background(AppColors.pink.opacity(vm.name.isEmpty ? 0.5 : 1))
                                    .foregroundColor(.black)
                                    .clipShape(Capsule())
                            }
                            .disabled(vm.name.isEmpty)

                            Spacer()

                            Button {
                                withAnimation { vm.hideList.toggle() }
                            } label: {
                                HStack {
                                    Image(systemName: vm.hideList ? "eye.slash" : "eye")
                                    Text(vm.hideList ? "Mostrar lista" : "Ocultar lista")
                                }
                                .foregroundColor(AppColors.text)
                            }
                        }
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.surface))

                    if !vm.hideList {
                        Text("Postres guardados")
                            .foregroundColor(AppColors.text)
                            .font(.headline)
                            .padding(.top, 6)

                        ForEach(vm.items) { p in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(p.nombre).foregroundColor(AppColors.text).font(.headline)
                                    Text("Creado: \(p.createdAt.formatted(date: .numeric, time: .shortened))")
                                        .font(.footnote).foregroundColor(AppColors.hint)
                                }
                                Spacer()
                                Text("Stock: \(p.stock)")
                                    .foregroundColor(AppColors.text)
                            }
                            .padding(16)
                            .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.surface))
                        }
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
    }
}

#Preview { NavigationStack { InventoryView() } }

