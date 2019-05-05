//
//  IngresoManager.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 23/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit


class IOIngresoManager {
    static var instance = IOIngresoManager()
    
    
    static var registros = [RegistroIngreso]()
    
    struct RegistroIngreso : Decodable {
        var childIDDebito : String?
        var childIDRubro : String?
        var descripcion : String?
        var fechaCreacion : String?
        var fechaGasto : String?
        var importe : Double?
        var isEnabled : Int?
        
        var queryByMonthYear : String?
        var queryByTypeMonthYear : String?
        var queryByTypeYear :String?
        var queryByYear : String?
    }
    
    
    static func loadRegistrosFromFirebase(mes: Int, año: Int, success: @escaping () -> Void, fail: @escaping (String) -> Void) {
        
        let path = UserID! + "/ingresos/registros"
        let queryKeyName = "queryByMonthYear"
        
        let nombreMes = MESES[mes]
        let añoStr = String(año)
        let periodo = nombreMes!+añoStr
        
        MLFirebaseDatabaseService.retrieve(path: path, keyName: queryKeyName, value: periodo) { (json, error) in
            guard error == nil else {
                fail(error?.localizedDescription ?? "Error")
                return
            }
            
            guard json != nil else {
                fail("json nil")
                return
            }
            
            do {
                
                let data = try JSONSerialization.data(withJSONObject: json!, options: [])
                registros = try JSONDecoder().decode([RegistroIngreso].self, from: data)
                success()
            } catch {
                print("error parsing: \(error.localizedDescription)")
                fail(error.localizedDescription)
            }
        }
    }
    
    static func getTotalRegistros() -> Double {
        var result : Double = 0
        for i in registros {
            result += i.importe ?? 0
        }
        
        return result
    }
    
    static func getTotal(childIDRubro: String) -> Double {
        var result : Double = 0
        for i in registros {
            if i.childIDRubro == childIDRubro {
                result += i.importe ?? 0
            }
        }
        return result
    }
    
    
}

