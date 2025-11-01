import Foundation
import CoreData

final class UserRepository {
    static let shared = UserRepository()

    // MARK: - Core Data stack (simple)
    lazy var persistentContainer: NSPersistentContainer = {
        // Asegúrate de que el nombre coincida con tu .xcdatamodeld
        let container = NSPersistentContainer(name: "PoliPostresModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    private init() {}

    // Ejemplo: autenticar usuario
    // Asume entidad "User" con atributos: email (String), password (String)
    func authenticate(email: String, password: String) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@", email)
        request.fetchLimit = 1

        do {
            if let user = try context.fetch(request).first {
                // En producción: comparar hash de contraseña
                if let storedPassword = user.value(forKey: "password") as? String {
                    return storedPassword == password
                }
            }
        } catch {
            print("Error fetch user: \(error)")
        }
        return false
    }

    // Función auxiliar para crear un usuario de prueba (solo para desarrollo)
    func createTestUserIfNeeded() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@", "test@polipostres.com")
        request.fetchLimit = 1

        do {
            let found = try context.fetch(request)
            if found.isEmpty {
                guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else { return }
                let newUser = NSManagedObject(entity: entity, insertInto: context)
                newUser.setValue("test@polipostres.com", forKey: "email")
                newUser.setValue("123456", forKey: "password") // en producción, NO guardar en texto plano
                try context.save()
            }
        } catch {
            print("Error creating test user: \(error)")
        }
    }
}

