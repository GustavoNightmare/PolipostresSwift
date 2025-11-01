import SwiftUI
import PhotosUI

struct InventoryView: View {
    @EnvironmentObject var auth: AuthViewModel              // 👈 para cerrar sesión
    @StateObject private var vm = InventoryViewModel()

    // Picker de fotos
    @State private var pickedItem: PhotosPickerItem? = nil
    @State private var pickedImageData: Data? = nil

    // Confirmación de borrado
    @State private var postreAEliminar: Postre? = nil

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

                    // ---------- Formulario ----------
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

                        // Selector de imagen + preview
                        VStack(alignment: .leading, spacing: 10) {
                            PhotosPicker(selection: $pickedItem, matching: .images, photoLibrary: .shared()) {
                                HStack {
                                    Image(systemName: "photo.on.rectangle")
                                    Text("Seleccionar imagen").bold()
                                }
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(AppColors.surface)
                                .foregroundColor(AppColors.text)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .onChange(of: pickedItem) { _, newValue in
                                Task {
                                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                        pickedImageData = data
                                        vm.newImageData = data
                                    }
                                }
                            }

                            if let data = pickedImageData, let uiImg = UIImage(data: data) {
                                Image(uiImage: uiImg)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                            }
                        }

                        HStack {
                            Button {
                                vm.addItem()
                                pickedItem = nil
                                pickedImageData = nil
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

                    // ---------- Lista (ocultable) ----------
                    if !vm.hideList {
                        Text("Postres guardados")
                            .foregroundColor(AppColors.text)
                            .font(.headline)
                            .padding(.top, 6)

                        ForEach(vm.items) { p in
                            HStack(spacing: 12) {
                                postreImage(p)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 56, height: 56)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(p.nombre).foregroundColor(AppColors.text).font(.headline)
                                    Text("Stock: \(p.stock)")
                                        .font(.subheadline).foregroundColor(AppColors.hint)
                                }

                                Spacer()

                                // ➕ sumar stock
                                Button { vm.increment(p) } label: {
                                    ZStack {
                                        Circle().stroke(AppColors.hint, lineWidth: 1.4).frame(width: 36, height: 36)
                                        Image(systemName: "plus").foregroundColor(AppColors.text)
                                    }
                                }

                                // 🗑️ eliminar (abre confirmación)
                                Button(role: .destructive) { postreAEliminar = p } label: {
                                    ZStack {
                                        Circle().stroke(Color.red.opacity(0.85), lineWidth: 1.4).frame(width: 36, height: 36)
                                        Image(systemName: "trash").foregroundColor(.red)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(16)
                            .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.surface))
                        }
                    } else {
                        Text("Lista oculta")
                            .foregroundColor(AppColors.hint)
                            .padding(.top, 4)
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
            // 👈 Cerrar sesión (izquierda)
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
            // 👉 Créditos (derecha)
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: CreditsView()) {
                    Image(systemName: "info.circle").foregroundColor(AppColors.text)
                }
            }
        }
        // Alerta de confirmación de borrado
        .alert("Eliminar postre",
               isPresented: Binding(
                   get: { postreAEliminar != nil },
                   set: { if !$0 { postreAEliminar = nil } }
               ),
               presenting: postreAEliminar) { postre in
            Button("Eliminar", role: .destructive) {
                vm.delete(postre)
                postreAEliminar = nil
            }
            Button("Cancelar", role: .cancel) {
                postreAEliminar = nil
            }
        } message: { postre in
            Text("¿Seguro que quieres eliminar \"\(postre.nombre)\"? Esta acción no se puede deshacer.")
        }
    }

    // MARK: - Helpers
    private func postreImage(_ p: Postre) -> Image {
        if let name = p.imageFilename,
           let data = LocalFileStore.readData(name),
           let ui = UIImage(data: data) {
            return Image(uiImage: ui)
        } else {
            return Image(systemName: "photo")   // placeholder
        }
    }
}

#Preview { NavigationStack { InventoryView().environmentObject(AuthViewModel()) } }
