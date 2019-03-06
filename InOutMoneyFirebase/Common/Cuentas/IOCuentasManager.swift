//
//  IOCuentasManager.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 25/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOCuentaManager {
    static var instance = IOCuentaManager()
    
    static var cuentas = [Cuenta]()
    
    class Cuenta {
        var childIDCuenta : String
        var descripcion : String
        var saldo : Double
        
        init(childIDCuenta: String, descripcion: String, saldo: Double) {
            self.childIDCuenta = childIDCuenta
            self.descripcion = descripcion
            self.saldo = saldo
        }
        
    }
    
    struct keyCuenta {
        static let childID = "childID"
        static let descripcion = "descripcion"
        static let saldo = "saldo"
    }
    
    private func parse(data: [String : Any]?) {
        if data == nil {return}
        
        for i in data! {
            if let registro = i.value as? [String : Any] {
                let childIDCuenta = i.key
                let descripcion = registro[keyCuenta.descripcion] as! String
                let saldo = registro[keyCuenta.saldo] as! Double
           
                let nuevoRegistro = Cuenta(childIDCuenta: childIDCuenta,
                                        descripcion: descripcion,
                                        saldo: saldo)
                
                IOCuentaManager.cuentas.append(nuevoRegistro)
                
            }
        }
        
    }
    
    static func loadCuentasFromFirebase(success: @escaping () -> Void, fail: @escaping (String) -> Void) {
        cuentas.removeAll()
         
        MLFirebaseDatabaseService.retrieveData(path: UserID! + "/cuentas") { (response, error) in
            if error != nil {
                fail(error?.localizedDescription ?? "Error")
                return
            }
            
            IOCuentaManager.instance.parse(data: response)
            
            success()
        }
    }
    
    
    static func getDescriptionArray() -> [String] {
        let array = cuentas.compactMap({ $0.descripcion })
        
        return array
    }
    
    static func getAmountArray() -> [Double] {
        let array = cuentas.compactMap({ $0.saldo })
        
        return array
    }
    
    static func getCodeArray() -> [String] {
        let array = cuentas.compactMap({ $0.childIDCuenta })
        
        return array
    }
    
    static func getDescriptionAndAmountArray() -> [String] {
        var array = [String]()
        for i in cuentas {
            array.append(i.descripcion + " " + i.saldo.formatoMoneda(decimales: 2, simbolo: "$"))
        }
        return array
    }
    
}
