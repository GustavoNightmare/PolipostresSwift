//
//  InventoryView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import SwiftUI

struct InventoryView: View {
    @StateObject private var viewModel = InventoryViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                // --- Añadir postre ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("Añadir postre")
                        .font(.headline)
                        .foregroundColor(AppTheme.primary)
                    
                    TextField("Nombre del postre", text: $viewModel.nombrePostre)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color(.systemGray6))
                    
                    TextField("Stock inicial", text: $viewModel.stockInicial)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color(.systemGray6))
                    
                    HStack {
                        Button(action: viewModel.guardarPostre) {
                            Label("Guardar", systemImage: "plus")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.nombrePostre.isEmpty || viewModel.stockInicial.isEmpty ? Color.gray : AppTheme.primary)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.nombrePostre.isEmpty || viewModel.stockInicial.isEmpty)
                        
                        Button(action: { viewModel.mostrarLista.toggle() }) {
                            Label(viewModel.mostrarLista ? "Ocultar lista" : "Mostrar lista", systemImage: "eye")
                                .padding()
                        }
                    }
                }
                .padding()
                .background(AppTheme.cardBackground)
                .cornerRadius(12)
                
                // --- Lista de postres ---
                if viewModel.mostrarLista {
                    Text("Postres guardados")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.postres) { postre in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(postre.nombre)
                                            .font(.headline)
                                        Text("Creado: \(viewModel.formatearFecha(postre.fechaCreacion))")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text("Stock: \(postre.stock)")
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.primary)
                                }
                                .padding()
                                .background(AppTheme.cardBackground)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("PoliPostres")
            .background(AppTheme.background.ignoresSafeArea())
        }
    }
}

#Preview {
    InventoryView()
}
