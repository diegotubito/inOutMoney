//
//  IORubroModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

struct IOProjectModel {
    struct Rubro : Decodable {
        var key : String
        var descripcion : String
        var fechaCreacion : String
        var isEnabled : Bool
        var type : String
        var counter : Int?
    }
    
    struct Cuenta : Decodable {
        var key : String
        var descripcion : String
        var saldo : Double
    }
    
    struct Registro : Decodable {
        var key : String?
        var childIDDebito : String?
        var childIDRubro : String?
        var descripcion : String?
        var fechaCreacion : String?
        var fechaGasto : String?
        var importe : Double?
        var isEnabled : Int?
        var descripcionRubro : String?
        
        var queryByMonthYear : String?
        var queryByTypeMonthYear : String?
        var queryByTypeYear :String?
        var queryByYear : String?
        
        var type : String?
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
        
        MLFirebaseDatabase.setData(path: path, diccionario: defaultValues, success: { (ref) in
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
    
    static func createDefaultAccountsToFirebase(path: String) throws {
        let default1 = ["childID" : "default1",
                        "descripcion" : "Efectivo",
                        "saldo" : 0] as [String : Any]
        let default2 = ["childID" : "default2",
                        "descripcion" : "Banco",
                        "saldo" : 0] as [String : Any]
            as [String : Any]
        
        
        let defaultValues = ["default1" : default1,
                             "default2" : default2]
        
        
        var error : Error?
        let semasphore = DispatchSemaphore(value: 1)
        
        MLFirebaseDatabase.setData(path: path, diccionario: defaultValues, success: { (ref) in
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

