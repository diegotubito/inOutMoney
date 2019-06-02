//
//  GastoManager.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IORegisterManager {
    static var instance = IORegisterManager()
    
    
    static var registros = [RegistroGasto]()
    
    struct RegistroGasto : Decodable {
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
        
        var type : String?
    }
    
    
//    func loadRegistersFromFirebase(with childIDRubro: String, success: @escaping () -> Void, fail: @escaping (String) -> Void) {
//        MLFirebaseDatabaseService.retrieveDataWithFilter(path: UserID! + "/gastos/registros", keyName: "childIDRubro", value: childIDRubro) { (response, error) in
//            if error != nil {
//                fail(error?.localizedDescription ?? "Error")
//                return
//            }
//
//            if response != nil {
//                for (key,value) in response! {
//                    var registro = value as! [String : Any]
//                    registro["childID"] = key
//                    IORegistroManager.instance.parseRegistro(data: registro)
//
//                }
//            }
//            success()
//        }
//    }
    
    static func loadRegistrosFromFirebase(mes: Int, año: Int, success: @escaping () -> Void, fail: @escaping (String) -> Void) {
    
        let path = UserID! + "/registros"
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
                registros = try JSONDecoder().decode([RegistroGasto].self, from: data)
                success()
            } catch {
                print("error parsing: \(error.localizedDescription)")
                fail(error.localizedDescription)
            }
        }
    }
    
    static func getTotalGasto() -> Double {
        var result : Double = 0
        for i in registros {
            if i.type == ProjectConstants.rubros.gastoKey {
                result += i.importe ?? 0
            }
        }
        
        return result
    }
    
    static func getTotalIngreso() -> Double {
        var result : Double = 0
        for i in registros {
            if i.type == ProjectConstants.rubros.ingresoKey {
                result += i.importe ?? 0
            }
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
