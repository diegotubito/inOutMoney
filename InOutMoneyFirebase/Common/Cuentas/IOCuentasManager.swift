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
    
    static var cuentas = [IOCuentasModel]()
    
    class IOCuentasModel {
        var codigo : String?
        var descripcion : String?
        var saldo : Double?
        
        init(codigo: String, descripcion: String, saldo: Double) {
            self.codigo = codigo
            self.descripcion = descripcion
            self.saldo = saldo
        }
        
    }
    
    static func loadCuentas(complete: @escaping () -> Void, fail: @escaping (String) -> Void) {
        MLFirebaseDatabaseService.retrieveData(path: UserID! + "/cuentas") { (response, error) in
            if error != nil {
                fail(error?.localizedDescription ?? "Error")
                return
            }
            
            if response != nil {
                cuentas.removeAll()
                for i in response! {
                    if let registro = i.value as? [String : Any] {
                        let nuevo = IOCuentasModel(codigo: registro["codigo"] as! String,
                                                   descripcion: registro["descripcion"] as! String,
                                                   saldo: registro["saldo"] as! Double)
                        
                        cuentas.append(nuevo)
                    }
                }
            }
            complete()
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
        let array = cuentas.compactMap({ $0.codigo })
        
        return array
    }
    
    static func getDescriptionAndAmountArray() -> [String] {
        var array = [String]()
        for i in cuentas {
            array.append(i.descripcion! + " " + (i.saldo?.formatoMoneda(decimales: 2, simbolo: "$"))!)
        }
        return array
    }
    
}
