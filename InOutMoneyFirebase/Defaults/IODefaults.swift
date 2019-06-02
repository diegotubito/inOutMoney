//
//  IODefaults.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IORemoteConfigKeys {
    static let login_usuario_background : String = "login_usuario_background"
 
    
}

class ProjectConstants {
    static let instance = ProjectConstants()
    
    struct firebaseSubPath {
        static let gastos = "/registros"
        static let ingresos = "/registros"
        static let rubros = "/rubros"
        static let cuentas = "/cuentas"
    }
    
    struct rubros {
        
        static let gastoKey = "_gas"
        static let ingresoKey = "_ing"
        
        static let codigo_descripcion = [gastoKey : "Gasto",
                                         ingresoKey : "Ingreso"]
        
        
        static func getDescripciones() -> [String] {
            var result = [String]()
            for (_, value) in ProjectConstants.rubros.codigo_descripcion {
                result.append(value)
            }
            
            return result
        }
        
        static func getKeys() -> [String] {
            var result = [String]()
            for (key, _) in ProjectConstants.rubros.codigo_descripcion {
                result.append(key)
            }
            
            return result
            
        }
    }
    
    
    
    static let unknownError = "Error desconocido"
}
