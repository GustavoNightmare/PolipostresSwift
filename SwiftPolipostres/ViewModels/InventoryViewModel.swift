//
//  InventoryViewModel.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation
import SwiftUI

@MainActor
class InventoryViewModel: ObservableObject {
    @Published var nombrePostre: String = ""
    @Published var stockInicial: String = ""
    @Published var mostrarLista: Bool = true
    @Published var postres: [Postre] = []
    
    // Función para agregar un nuevo postre
    func guardarPostre() {
        guard !nombrePostre.isEmpty, let stock = Int(stockInicial) else { return }
        
        let nuevoPostre = Postre(
            nombre: nombrePostre,
            stock: stock,
            fechaCreacion: Date()
        )
        postres.append(nuevoPostre)
        
        // Limpiar campos
        nombrePostre = ""
        stockInicial = ""
    }
    
    // Formatear fecha
    func formatearFecha(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        return formatter.string(from: date)
    }
}
