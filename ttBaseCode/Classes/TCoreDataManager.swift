import Foundation
import CoreData

public class TCoreDataManager {
    
    /// entity名称
    var name: String!
    
    public init(_ name: String) {
        self.name = name
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            } else {
                debugPrint("===== 【 entity说明 \n \(storeDescription) 】  =====")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
        
    lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
        
    public func createEntity<T: NSManagedObject>() -> T? {
        let entityName = String(describing: T.self)
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return nil
        }
        let newObject = NSManagedObject(entity: entity, insertInto: context) as? T
        return newObject
    }
    
    @available(iOS 13.0, *)
    public func createEntityInBackground<T: NSManagedObject>() async -> T? {
        await withCheckedContinuation { continuation in
            backgroundContext.perform {
                let entityName = String(describing: T.self)
                guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.backgroundContext) else {
                    continuation.resume(returning: nil)
                    return
                }
                let newObject = NSManagedObject(entity: entity, insertInto: self.backgroundContext) as? T
                continuation.resume(returning: newObject)
            }
        }
    }
    
    public func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            debugPrint("Failed to fetch entities: \(error)")
            return []
        }
    }

    @available(iOS 13.0, *)
    public func fetchInBackground<T: NSManagedObject>(request: NSFetchRequest<T>) async -> [T] {
        await withCheckedContinuation { contnuation in
            backgroundContext.perform {
                do {
                    let results = try self.backgroundContext.fetch(request)
                    contnuation.resume(returning: results)
                } catch {
                    debugPrint("Failed to fetch entities: \(error)")
                    contnuation.resume(returning: [])
                }
            }
        }
    }

    public func fetchEntities<T: NSManagedObject>(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) -> [T] {
        let request: NSFetchRequest<T> = T.createFetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let fetchLimit = fetchLimit {
            request.fetchLimit = fetchLimit
        }
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            debugPrint("Failed to fetch entities: \(error)")
            return []
        }
    }
    
    @available(iOS 13.0, *)
    public func fetchEntitiesInBackground<T: NSManagedObject>(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) async -> [T] {
        await withCheckedContinuation { continuation in
            backgroundContext.perform {
                let request: NSFetchRequest<T> = T.createFetchRequest()
                request.predicate = predicate
                request.sortDescriptors = sortDescriptors
                if let fetchLimit = fetchLimit {
                    request.fetchLimit = fetchLimit
                }
                do {
                    let results = try self.backgroundContext.fetch(request)
                    continuation.resume(returning: results)
                } catch {
                    debugPrint("Failed to fetch entities: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @available(iOS 13.0, *)
    public func saveBackgroundContext() async {
        await withCheckedContinuation { continuation in
            backgroundContext.perform {
                if self.backgroundContext.hasChanges {
                    do {
                        try self.backgroundContext.save()
                        continuation.resume()
                    } catch {
                        let nserror = error as NSError
                        debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    public func deleteEntity(_ entity: NSManagedObject) {
        context.delete(entity)
        saveContext()
    }
    
    @available(iOS 13.0, *)
    public func deleteEntityInBackground(_ entity: NSManagedObject) async {
        await withCheckedContinuation { continuation in
            backgroundContext.perform {
                self.backgroundContext.delete(entity)
                do {
                    try self.backgroundContext.save()
                    continuation.resume()
                } catch {
                    let nserror = error as NSError
                    debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        
    }
}

extension NSManagedObject {
    class func createFetchRequest<T: NSManagedObject>() -> NSFetchRequest<T> {
        return .init(entityName: String(describing: T.self))
    }
}
