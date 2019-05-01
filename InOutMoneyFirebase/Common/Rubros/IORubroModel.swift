//
//  IORubroModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IORubroManager {
    static var instance = IORubroManager()
    
    static var rubros = [Rubro]()
    
    class Rubro {
        var childID : String
        var descripcion : String
        var fechaCreacion : Date
        var isEnabled : Bool
        
        init(childID: String, descripcion: String, fechaCreacion: Date, isEnabled: Bool) {
            self.childID = childID
            self.descripcion = descripcion
            self.fechaCreacion = fechaCreacion
            self.isEnabled = isEnabled
        }
        
        
    }
    
    
    
    struct keyRubro {
        static let childID = "childID"
        static let descripcion = "descripcion"
        static let fechaCreacion = "fechaCreacion"
        static let isEnabled = "isEnabled"
    }
    
  
    
    
    private func parse(data: [String : Any]?) {
        if data == nil {return}
        
        for i in data! {
            if let registro = i.value as? [String : Any] {
                let childID = i.key
                let descripcion = registro[keyRubro.descripcion] as! String
                let fechaStr = registro[keyRubro.fechaCreacion] as! String
                let fecha = fechaStr.toDate(formato: formatoDeFecha.fechaConHora)
                let isEnabled = registro[keyRubro.isEnabled] as! Bool
              
                let nuevoRegistro = Rubro(childID: childID,
                                       descripcion: descripcion,
                                       fechaCreacion: fecha!,
                                       isEnabled: isEnabled)
                
                IORubroManager.rubros.append(nuevoRegistro)
                
            }
        }
        
    }
    
   
    
   
    
    static func loadRubrosFromFirebase(success: @escaping () -> Void, fail: @escaping (String) -> Void) {
        rubros.removeAll()
        
        MLFirebaseDatabaseService.retrieveData(path: UserID! + "/gastos/rubros") { (response, error) in
            if error != nil {
                fail(error?.localizedDescription ?? "Error")
                return
            }
            
            IORubroManager.instance.parse(data: response)
            
            success()
        }
    }
    
    
    static func createDefaultRubrosToFirebase(path: String) throws {
        let default1 = ["descripcion" : "Servicios",
                        "fechaCreacion" : Date().toString(formato: formatoDeFecha.fechaConHora),
                        "isEnabled" : true] as [String : Any]
        let default2 = ["descripcion" : "Impuestos",
                        "fechaCreacion" : Date().toString(formato: formatoDeFecha.fechaConHora),
                        "isEnabled" : true] as [String : Any]
        let default3 = ["descripcion" : "Carnicería",
                        "fechaCreacion" : Date().toString(formato: formatoDeFecha.fechaConHora),
                        "isEnabled" : true] as [String : Any]
            as [String : Any]
        
        
        let defaultValues = ["default1" : default1,
                             "default2" : default2,
                             "default3" : default3]
        
        
        var error : Error?
        let semasphore = DispatchSemaphore(value: 1)
        
        MLFirebaseDatabaseService.setData(path: path, diccionario: defaultValues, success: { (ref) in
            semasphore.signal()
        }) { (err) in
            error = err
            semasphore.signal()
        }
        
        _ = semasphore.wait(timeout: .distantFuture)
        if error != nil {
            throw error!
        }
        return
        
    }
   
}

