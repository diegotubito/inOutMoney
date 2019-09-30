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
    
    struct colors {
        static let swipeEditar = UIColor.init(red: 0.0, green: 0.7, blue: 0.0, alpha: 0.7)
        static let swipeAnular = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7)
        static let swipeReestablecer = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7)
        static let swipeEliminar = UIColor.red
    }
    
    struct firebaseSubPath {
        static let registros = "/registros"
        static let rubros = "/rubros"
        static let cuentas = "/cuentas"
    }
    
    struct queryKeyNames {
        static let query_MonthYear = "queryByMonthYear"
        static let query_TypeMonthYear = "queryByTypeMonthYear"
        static let query_TypeYear = "queryByTypeYear"
        static let query_Year = "queryByYear"
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
    
    struct KeyNames {
        struct Registro {
            static let queryByTypeMonthYear = ProjectConstants.queryKeyNames.query_TypeMonthYear
            static let queryByTypeYear      = ProjectConstants.queryKeyNames.query_TypeYear
            static let queryByMonthYear     = ProjectConstants.queryKeyNames.query_MonthYear
            static let queryByYear          = ProjectConstants.queryKeyNames.query_Year
            static let childIDRubro         = "childIDRubro"
            static let isEnabled            = "isEnabled"
            static let childIDDebito        = "childIDDebito"
            static let descripcion          = "descripcion"
            static let fechaGasto           = "fechaGasto"
            static let fechaCreacion        = "fechaCreacion"
            static let importe              = "importe"
            static let type                 = "type"
            static let descripcionRubro     = "descripcionRubro"
            
        }
        
        struct Rubro {
            //firebase keys
            static let descripcion = "descripcion"
            static let fechaCreacion = "fechaCreacion"
            static let isEnabled = "isEnabled"
            static let type = "type"
        }
    }
    
    
    
    static let unknownError = "Error desconocido"
    static let loadingText = "Cargado"
}
