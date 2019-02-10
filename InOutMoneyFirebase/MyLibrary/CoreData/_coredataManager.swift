//
//  coreDataManagerProductos.swift
//  coreGymMobile
//
//  Created by David Diego Gomez on 9/8/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit
import CoreData

class _coredataManager {
    //MARK: - singleton
    private static var coordinator: _coredataManager?
    
    public class func shareInstance() -> _coredataManager {
        if coordinator == nil {
            coordinator = _coredataManager()
        }
        return coordinator!
    }
    
    //MARK: - init
    public var container : NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "coreGymMobile")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("unresolved error \(error)")
            }
        }
    }
    
    //MARK: - Perform methods
    static func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        _coredataManager.shareInstance().container.performBackgroundTask(block)
    }
    
    static func performViewTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        block(_coredataManager.shareInstance().container.viewContext)
    }
    
    /*
    static func asyncFetch(entidad: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, completion: @escaping ([NSManagedObject]?) -> Void) {
        
        
        // Creates a fetch request to get all the dogs saved
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        // Creates `asynchronousFetchRequest` with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            
            // Retrieves an array of dogs from the fetch result `finalResult`
            guard let result = asynchronousFetchResult.finalResult as? [NSManagedObject] else { return }
            
            // Dispatches to use the data in the main queue
            DispatchQueue.main.async {
                // Do something
                completion(result)
            }
        }
        
        do {
            
            // Keeps a reference of `NSPersistentStoreAsynchronousResult` returned by `execute`
            _ = try _coredataManager.shareInstance().container.viewContext.execute(asynchronousFetchRequest) as? NSPersistentStoreAsynchronousResult
            
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
        }
    }
    
    */
    
    static func performBackgroundFetch(entidad: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, completionHandler: @escaping ([NSManagedObject]?) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        var result : [NSManagedObject]?
        
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        _coredataManager.shareInstance().container.performBackgroundTask { (context) in
            do {
                fetchRequest.returnsObjectsAsFaults = false
                result = try _coredataManager.shareInstance().container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
                completionHandler(result)
                return
            } catch {
                print("error")
                completionHandler(nil)
            }
        }
    }
    
    static func fetch(entidad: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, completionHandler: @escaping ([NSManagedObject]?) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        var result : [NSManagedObject]?
        
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        
        do {
            fetchRequest.returnsObjectsAsFaults = false
            result = try _coredataManager.shareInstance().container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            completionHandler(result)
            return
        } catch {
            print("error")
            completionHandler(nil)
        }
        
    }
    
    
    static func removeEntity(entidad: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        let context = _coredataManager.shareInstance().container.viewContext
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Entidad \(entidad) eliminada")
        
        } catch {
            print ("Error al intentar vaciar entidad \(entidad)")
        }
        return
    }
    
    
    private func updateObject(context: NSManagedObjectContext, entidad: String, diccionario: [String : Any]) -> NSManagedObject? {
        if let childID = diccionario["childID"] as? String {
            
            let predicate = NSPredicate(format: "childID = %@", childID)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
            fetchRequest.predicate = predicate
            
            var results : [NSManagedObject]?
            
            //FETCH
            do {
                results = try context.fetch(fetchRequest) as? [NSManagedObject]
                
                if results?.count == 1 {
                    //editar si es que es necesario
                    
                    if let childIDEdicion = results![0].value(forKey: "childIDEdicion") as? String {
                        if childIDEdicion == diccionario["childIDEdicion"] as? String {
                            print("No hace falta editar \(entidad) \(childID)")
                            return nil
                        } else {
                            
                            //editamos
                            results![0].setValuesForKeys(diccionario)
                            
                            //SAVE
                            do {
                                //  if context.hasChanges {
                                try context.save()
                                print("\(String(describing: (results?.count)!)) objeto modificado en entidad \(entidad)")
                                
                                NotificationCenter.default.post(name: .coredataNotification, object: results?[0], userInfo: ["entidad": entidad,
                                                                                                                             "tipoDeAviso" : _tipoDeAviso.update])
                                //  }
                                return results![0]
                            } catch {
                                print("error al intentar modificar entidad \(entidad)")
                                return nil
                            }
                            
                        }
                    }
                    
                    
                }
                
            } catch {
                print("fetch error al intentar modificar entidad \(entidad)")
                return nil
            }
            
            
            let newObject: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entidad, into: context)
            newObject.setValuesForKeys(diccionario)
            
            //SAVE
            do {
                try context.save()
                NotificationCenter.default.post(name: .coredataNotification, object: newObject, userInfo: ["entidad": entidad,
                                                                                                           "tipoDeAviso" : _tipoDeAviso.alta])
                
                print("Nuevo objeto en entidad \(entidad)")
                return newObject
            } catch {
                print("error al guardar objeto en background. Entidad: \(entidad)")
            }
            
            
        }
        
        return nil
        
    }
    
    static func updateBackground(entidad: String, diccionario: [String : Any]) {
        
        _coredataManager.performBackgroundTask({
            context in
            
            _coredataManager.shareInstance().updateObject(context: context, entidad: entidad, diccionario: diccionario)
        })
        
        
    }
    
    static func edit(entidad: String, diccionario: [String: Any]) {
        if let childID = diccionario["childID"] as? String {
            
            let context = _coredataManager.shareInstance().container.viewContext
            
            let predicate = NSPredicate(format: "childID = %@", childID)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
            fetchRequest.predicate = predicate
            
            var results : [NSManagedObject]?
            
            //FETCH
            do {
                results = try context.fetch(fetchRequest) as? [NSManagedObject]
                
                if results?.count == 1 {
                    //editamos
                    results![0].setValuesForKeys(diccionario)
                    
                    //SAVE
                    do {
                 //       if context.hasChanges {
                            try context.save()
                            print("\(String(describing: (results?.count)!)) objeto modificado en entidad \(entidad)")
                            
                            NotificationCenter.default.post(name: .coredataNotification, object: results?[0], userInfo: ["entidad": entidad,
                                                "tipoDeAviso" : _tipoDeAviso.edit])
                        
                     
                 //       }
                        return
                    } catch {
                        print("error al intentar modificar entidad \(entidad)")
                        return
                    }
                    
                    
                    
                }
                
            } catch {
                print("fetch error al intentar modificar entidad \(entidad)")
                return
            }
        }
    }
    
    static func update(entidad: String, diccionario: [String : Any]) -> NSManagedObject? {
        let context = _coredataManager.shareInstance().container.viewContext
        
        let object = _coredataManager.shareInstance().updateObject(context: context, entidad: entidad, diccionario: diccionario)
        
        return object
    }
    
    static func addNew(entidad: String, diccionario: [String : Any]) -> NSManagedObject? {
        let context = _coredataManager.shareInstance().container.viewContext
        
        let object = _coredataManager.shareInstance().addNewObject(context: context, entidad: entidad, diccionario: diccionario)
        
        return object
    }
    
    //remove en el main thread
    static func removeObjects(entidad: String, predicate: NSPredicate) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        
        let context = _coredataManager.shareInstance().container.viewContext
        
        fetchRequest.predicate = predicate
        do{
            let result = try context.fetch(fetchRequest)
            
            if result.count > 0 {
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    print("\(result.count) objeto/s eliminados de la entidad \(entidad)")
                    try context.execute(deleteRequest)
                    try context.save()
                    return result[0] as? NSManagedObject
                } catch {
                    print ("Error al intentar eliminar objeto/s en entidad \(entidad)")
                }
            } else {
                print("No existe objeto/s en entidad \(entidad)")
            }
        }catch {
            print("Fetch Failed: \(error)")
        }
        return nil
    }
    
    static func uniqueChildID(entidad: String, numberOfTry: Int, length: Int, completionHandler: @escaping (String?) -> Void) {
        
        var intentos = 0
        while intentos < numberOfTry {
            let childIDGenerado = String.random(length: length)
            let predicate = NSPredicate(format: "childID = %@", childIDGenerado)
            
            _coredataManager.fetch(entidad: entidad, predicate: predicate, sortDescriptors: nil, completionHandler: {datos -> Void in
                if datos?.count == 0 {
                    completionHandler(childIDGenerado)
                    intentos = numberOfTry
                }
                intentos += 1
            })
            
            
        }
        if intentos == numberOfTry + 1 {
            print("unique childID success entity \(entidad)")
        } else {
            print("failed createing uinique ChildID at entity \(entidad)")
            completionHandler(nil)
        }
    }
    
    private func addNewObject(context: NSManagedObjectContext, entidad: String, diccionario: [String : Any]) -> NSManagedObject? {
        
        let newObject: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entidad, into: context)
        newObject.setValuesForKeys(diccionario)
        
        //SAVE
        do {
            try context.save()
            NotificationCenter.default.post(name: .coredataNotification, object: newObject, userInfo: ["entidad": entidad,
                                                                                                       "tipoDeAviso" : _tipoDeAviso.alta])
            
            print("Nuevo objeto en entidad \(entidad)")
            return newObject
        } catch {
            print("error al guardar objeto en background. Entidad: \(entidad)")
        }
        
        return nil
        
    }
    
}
