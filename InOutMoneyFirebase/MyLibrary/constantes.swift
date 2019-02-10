//
//  constantes.swift
//  coreGym
//
//  Created by David Diego Gomez on 11/7/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//


import Foundation

let FORMATO_NIL = "dd/MM/yyyy"
let FECHA_NIL = "01/01/1800"
let FECHA_CON_HORA = "dd-MM-yyyy HH:mm:ss"
let FECHA_CON_HORA_SIN_SEGUNDOS = "dd-MM-yyyy HH:mm"
let FECHA = "dd-MM-yyyy"
let HORA = "HH:mm:ss"
let HORA_SIN_SEGUNDOS = "HH:mm"
let HORA_24HS = "HH:mm a"
let HORA_CONSEGUNDOS_24HS = "HH:mm:ss a"

let DIAS = [1:"Domingo".localized, 2: "Lunes".localized, 3: "Martes".localized, 4: "Miércoles".localized, 5: "Jueves".localized, 6: "Viernes".localized, 7: "Sábado".localized]
let MESES = [1:"Enero".localized, 2:"Febrero".localized, 3:"Marzo".localized, 4:"Abril".localized, 5:"Mayo".localized, 6:"Junio".localized, 7:"Julio".localized, 8:"Agosto".localized, 9:"Septiembre".localized, 10:"Octubre".localized, 11:"Noviembre".localized, 12:"Diciembre".localized]

enum _tipoDeAviso {
    static let alta : Int = 0
    static let baja : Int = 1
    static let update : Int = 2
    static let consulta : Int = 3
    static let dataError : Int = 4
    static let communicationError : Int = 5
    static let entidadVacia : Int = 6
    
    static let relacion : Int = 5
    static let edit = 6
}

enum _pathResult {
    case activa
    case inactiva
    case error
    case sinPaths
}

let nombreArchivoBackup = "backup"


