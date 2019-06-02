//
//  IORegistroManager.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//


import UIKit

class IORegistroManager {
    static var instance = IORegistroManager()
    
    static var registros = [Registro]()
    
    struct keyRegistro {
        static let childID = "childID"
        static let childIDRubro = "childIDRubro"
        static let childIDDebito = "childIDDebito"
        static let descripcion = "descripcion"
        static let fechaCreacion = "fechaCreacion"
        static let fechaGasto = "fechaGasto"
        static let importe = "importe"
        static let isEnabled = "isEnabled"
    }
    
    class Registro {
        var childID : String
        var childIDRubro : String
        var childIDCuentaDebito : String
        var descripcion : String
        var fechaCreacion : Date
        var fechaGasto : Date
        var importe : Double
        var isEnabled : Bool
        
        init(childID: String, childIDRubro: String, childIDCuentaDebito: String, descripcion: String, fechaCreacion: Date, fechaGasto: Date, importe: Double, isEnabled: Bool) {
            self.childID = childID
            self.childIDRubro = childIDRubro
            self.childIDCuentaDebito = childIDCuentaDebito
            self.descripcion = descripcion
            self.fechaCreacion = fechaCreacion
            self.fechaGasto = fechaGasto
            self.importe = importe
            self.isEnabled = isEnabled
            
        }
    }
    
    private func parseRegistro(data: [String : Any]) {
        
        let childID = data[keyRegistro.childID] as! String
        let childIDRubro = data[keyRegistro.childIDRubro] as! String
        let childIDCuentaDebito = data[keyRegistro.childIDDebito] as! String
        let descripcion = data[keyRegistro.descripcion] as! String
        let fechaCreacionStr = data[keyRegistro.fechaCreacion] as! String
        let fechaCreacion = fechaCreacionStr.toDate(formato: formatoDeFecha.fechaConHora)
        let fechaGastoStr = data[keyRegistro.fechaGasto] as! String
        let fechaGasto = fechaGastoStr.toDate(formato: formatoDeFecha.fecha)
        let importe = data[keyRegistro.importe] as! Double
        let isEnabled = data[keyRegistro.isEnabled] as! Bool
        
        let nuevoRegistro = Registro(childID: childID, childIDRubro: childIDRubro,
                                     childIDCuentaDebito: childIDCuentaDebito,
                                     descripcion: descripcion,
                                     fechaCreacion: fechaCreacion!,
                                     fechaGasto: fechaGasto!,
                                     importe: importe,
                                     isEnabled: isEnabled)
        
        IORegistroManager.registros.append(nuevoRegistro)
        
     
        
        
    }
    
    func loadAllRegisterFromFirebase(with childIDRubro: String, success: @escaping () -> Void, fail: @escaping (String) -> Void) {
        MLFirebaseDatabaseService.retrieveDataWithFilter(path: UserID! + "/registros", keyName: "childIDRubro", value: childIDRubro) { (response, error) in
            if error != nil {
                fail(error?.localizedDescription ?? "Error")
                return
            }
            
            if response != nil {
                for (key,value) in response! {
                    var registro = value as! [String : Any]
                    registro["childID"] = key
                    IORegistroManager.instance.parseRegistro(data: registro)
                    
                }
            }
            success()
        }
    }
    
    static func loadRegistrosFromFirebase(mes: Int, año: Int, success: @escaping () -> Void, fail: @escaping (String) -> Void) {
        
        
        let nombreMes = MESES[mes]
        let añoStr = String(año)
        let periodo = nombreMes!+añoStr
        
        MLFirebaseDatabaseService.retrieveDataWithFilter(path: UserID! + "/registros", keyName: "queryByMonthYear", value: periodo) { (response, error) in
            if error != nil {
                fail(error?.localizedDescription ?? "Error")
                return
            }
            
            registros.removeAll()
            if response != nil {
                for (key,value) in response! {
                    var registro = value as! [String : Any] 
                    registro["childID"] = key
                    IORegistroManager.instance.parseRegistro(data: registro)
                }
            }
            success()
        }
        
       
    }
    
    static func getTotalRegistros() -> Double {
        var result : Double = 0
        for i in IORegistroManager.registros {
            result += i.importe
        }
        
        return result
    }
    
    static func getTotal(childIDRubro: String) -> Double {
        var result : Double = 0
        for i in registros {
            if i.childIDRubro == childIDRubro {
                result += i.importe
            }
        }
        return result
    }
    
    
}

