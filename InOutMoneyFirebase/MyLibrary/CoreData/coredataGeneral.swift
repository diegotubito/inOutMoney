//
//  coredataGeneral.swift
//  coreGymMobile
//
//  Created by David Diego Gomez on 24/8/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//
/*

import UIKit
import CoreData

class _coredataGeneral {
    static let instance = _coredataGeneral()
    
    
    func removeObjects(context: NSManagedObjectContext, entidad: String, atributo: String, valor: Any?, operador: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        
        
        let predicate = getPredicate(atributo: atributo, valor: valor, operador: operador)
        
        fetchRequest.predicate = predicate
        do{
            let result = try context.fetch(fetchRequest)
            
            if result.count > 0 {
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    print("\(result.count) objeto/s eliminados de la entidad \(entidad)")
                    try context.execute(deleteRequest)
                    try context.save()
                    return true
                } catch {
                    print ("Error en eliminar objeto/s en entidad \(entidad)")
                }
            } else {
                print("No existe Objeto/s \(atributo) = \(valor ?? "") en entidad \(entidad), funcion Eliminar cancelada")
            }
        }catch {
            print("Fetch Failed: \(error)")
        }
        return false
    }
    
    
    func removeEntity(context: NSManagedObjectContext, entidad: String) -> Bool {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Entidad \(entidad) eliminada")
            
            return true
        } catch {
            print ("Error al intentar vaciar entidad \(entidad)")
        }
        return false
    }
    
    
    func edit(context: NSManagedObjectContext, entidad: String, atributo: String, valor: Any?, diccionario: [String : Any]) -> Bool{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        
        let predicate = getPredicate(atributo: atributo, valor: valor, operador: "=")
        
        fetchRequest.predicate = predicate
        do {
            //preparo los guardos en memoria
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 { // At least one was returned
                    
                    // el diccionario solo contiene los campos a modificar, el resto no se toca.
                    for i in results {
                        
                        i.setValuesForKeys(diccionario)
                    }
                    
                }
                //los guardo fisicamente
                do {
                    //solo modifico si hay cambios.
                    if context.hasChanges {
                        print("\(results.count) objeto modificado en entidad \(entidad)")
                        try context.save()
                        
                        return true
                    }
                }
                catch {
                    print("Saving Core Data Failed: \(error)")
                }
            }
            
            
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        
        return false
    }
    
    func insertNewObject(context: NSManagedObjectContext, entidad: String, diccionario: [String : Any]) -> Bool{
        
        let nuevo: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entidad, into: context)
        nuevo.setValuesForKeys(diccionario)
        
        do {
            try context.save()
            return true
        }catch {
            print("error al intentar guardar nuevo objeto en \(entidad)")
        }
        
        return false
        
    }
    
    func fetch(context: NSManagedObjectContext, entidad: String, atributo: String, valor: Any?, operador: String) -> [NSManagedObject]? {
        if let predicate = getPredicate(atributo: atributo, valor: valor, operador: operador) {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
            
            var result : [NSManagedObject]?
            
            fetchRequest.predicate = predicate
            do{
                result = try context.fetch(fetchRequest ) as? [NSManagedObject]
                
            }catch {
                print("error al buscar objeto en \(entidad)")
            }
            
            return result
        } else {
            print("predicate error")
            return nil
            
        }
    }
    
    func fetch(context: NSManagedObjectContext, entidad: String, atributo: String, desde: Any, hasta: Any) -> [NSManagedObject]? {
        if let predicate = getPredicateDesdeHasta(atributo: atributo, desde: desde, hasta: hasta) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
            var result : [NSManagedObject]?
            
            fetchRequest.predicate = predicate
            do{
                result = try context.fetch(fetchRequest ) as? [NSManagedObject]
                
            }catch {
                print("error al buscar objeto en \(entidad)")
            }
            
            return result
        } else {
            print("predicate error")
            return nil
        }
    }
    
    func fetch(context: NSManagedObjectContext, entidad: String, predicate: NSPredicate) -> [NSManagedObject]? {
        //EJEMPLOS
        //[cd] = c: case insensitive, d: diacritic insensitive
        //let predicate = NSPredicate(format: "descripcion CONTAINS[cd] %@", "power")
        //let predicate = NSPredicate(format: "descripcion CONTAINS[cd] %@ AND rubro CONTAINS[cd] %@", "power", "bebida")
        //let predicate = NSPredicate(format: "stockActual > stockMinimo AND isActive = false")
        //let predicate = NSPredicate(format: "stockActual > stockMinimo AND proveedores.descripcion CONTAINS[cd] %@", "nuevo")
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        var result : [NSManagedObject]?
        
        fetchRequest.predicate = predicate
        do{
            result = try context.fetch(fetchRequest ) as? [NSManagedObject]
            
        }catch {
            print("error al buscar objeto en \(entidad)")
        }
        
        return result
    }
    
    func fetch(context: NSManagedObjectContext, entidad: String) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
        
        var result : [NSManagedObject]?
        
        do{
            result = try context.fetch(fetchRequest) as? [NSManagedObject]
            
        }catch {
            print("error al buscar objeto en \(entidad)")
        }
        
        return result
    }
    
}


extension _coredataGeneral {
    
    func getPredicateDesdeHasta(atributo: String, desde: Any, hasta: Any?) -> NSPredicate? {
        var predicate : NSPredicate?
        
        if let valorAux1 = desde as? Double {
            if let valorAux2 = hasta as? Double {
                predicate = NSPredicate(format: "\(atributo) >= %f AND \(atributo) <= %f", valorAux1, valorAux2)
                
            }
        }else if let valorAux1 = desde as? Int32 {
            if let valorAux2 = hasta as? Int32 {
                predicate = NSPredicate(format: "\(atributo) >= %d AND \(atributo) <= %d", valorAux1, valorAux2)
                
            }
        }else if let valorAux1 = desde as? Int64 {
            if let valorAux2 = hasta as? Int64 {
                predicate = NSPredicate(format: "\(atributo) >= %d AND \(atributo) <= %d", valorAux1, valorAux2)
                
            }
        }else if let valorAux1 = desde as? Int {
            if let valorAux2 = hasta as? Int {
                predicate = NSPredicate(format: "\(atributo) >= %d AND \(atributo) <= %d", valorAux1, valorAux2)
                
            }
        }else if let valorAux1 = desde as? Float {
            if let valorAux2 = hasta as? Float {
                predicate = NSPredicate(format: "\(atributo) >= %d AND \(atributo) <= %d", valorAux1, valorAux2)
                
            }
        } else if let valorAux1 = desde as? Date {
            if let valorAux2 = hasta as? Date {
                var aux = DateString(fecha: valorAux1, formato: FECHA)
                aux.append(" 00:00:00")
                let fechaInicial = stringDate(fecha: aux, formato: FECHA_CON_HORA)
                
                var aux2 = DateString(fecha: valorAux2, formato: FECHA)
                aux2.append(" 23:59:59")
                let fechaFinal = stringDate(fecha: aux2, formato: FECHA_CON_HORA)
                
                predicate = NSPredicate(format: "\(atributo) >= %@ AND \(atributo) <= %@", fechaInicial! as NSDate, fechaFinal! as NSDate)
                
            }
        }
        return predicate
    }
    
    func getPredicate(atributo: String, valor: Any?, operador: String) -> NSPredicate? {
        var predicate : NSPredicate?
        
        if let valorAux = valor as? Bool {
            predicate = NSPredicate(format: "\(atributo) \(operador) %@", NSNumber(value: valorAux))
        } else if let valorAux = valor as? String {
            //         predicate = NSPredicate(format: "\(atributo) CONTAINS[c] '\(valorAux)'")
            predicate = NSPredicate(format: "\(atributo) \(operador) %@", valorAux)
        } else if let valorAux = valor as? Int32 {
            predicate = NSPredicate(format: "\(atributo) \(operador) %d", valorAux)
            
        }  else if let valorAux = valor as? Int64 {
            predicate = NSPredicate(format: "\(atributo) \(operador) %d", valorAux)
            
        } else if let valorAux = valor as? Int {
            predicate = NSPredicate(format: "\(atributo) \(operador) %d", valorAux)
            
        }else if let valorAux = valor as? Double {
            predicate = NSPredicate(format: "\(atributo) \(operador) %f", valorAux)
        }else if let valorAux = valor as? Float {
            predicate = NSPredicate(format: "\(atributo) \(operador) %f", valorAux)
        }
        else if let valorAux = valor as? Date {
            if operador == "=" {
                
                var aux = DateString(fecha: valorAux, formato: FECHA)
                aux.append(" 00:00:00")
                let fechaInicial = stringDate(fecha: aux, formato: FECHA_CON_HORA)
                
                var aux2 = DateString(fecha: valorAux, formato: FECHA)
                aux2.append(" 23:59:59")
                let fechaFinal = stringDate(fecha: aux2, formato: FECHA_CON_HORA)
                
                predicate = NSPredicate(format: "\(atributo) >= %@ AND \(atributo) <= %@", fechaInicial! as NSDate, fechaFinal! as NSDate)
            } else {
                var aux = DateString(fecha: valorAux, formato: FECHA)
                if operador == "<" {
                    aux.append(" 00:00:00")
                } else {
                    aux.append(" 23:59:59")
                }
                let fechaTope = stringDate(fecha: aux, formato: FECHA_CON_HORA)
                
                predicate = NSPredicate(format: "\(atributo) \(operador) %@", fechaTope! as NSDate)
            }
        } else if valor == nil {
            predicate = NSPredicate(format: "\(atributo) \(operador) nil")
            
        }
        
        return predicate
    }
}
*/
