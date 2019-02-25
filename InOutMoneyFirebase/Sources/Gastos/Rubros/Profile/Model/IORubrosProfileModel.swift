//
//  IORubrosProfileModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

enum IORubrosProfileType {
    case headerInfo
    case botonAgregarRegistro
    case registros
}

class IORubrosProfileModel {
    var rubroRecibido : IORubrosListadoModel.rowData
    var items = [IORubrosProfileItem]()
    var registrosGastos = [IORegistroGastos]()
    var fechaSeleccionada = Date()
    
    init(rubro: IORubrosListadoModel.rowData) {
        self.rubroRecibido = rubro
        
    }
}

class Profile {
    var registros = [IORegistroGastos]()
    
    init?(data: [String : Any]) {
        for (_, value) in data {
            let nuevo = IORegistroGastos(json: value as! [String : Any])
            registros.append(nuevo)
        }

            
    
        
    }
}

protocol IORubrosProfileItem {
    var type: IORubrosProfileType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

//HEADER
class IORubrosHeader {
    var mes : String?
    var total : Double?
    
    init(mes: String, total: Double) {
        self.mes = mes
        self.total = total
    }
}

class ProfileViewModelRubrosHeaderItem: IORubrosProfileItem {
    var type: IORubrosProfileType {
        return .headerInfo
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var mes: String
    var total: Double
    var rubro : String
    
    init(mes: String, total: Double, rubro: String) {
        self.mes = mes
        self.total = total
        self.rubro = rubro
    }
}

//REGISTROS
class IORegistroGastos {
    var descripcion: String?
    var fechaGasto: Date?
    var fechaCreacion : Date?
    var importe : Double?
    var isEnabled : Bool
    
    init(json: [String: Any]) {
        self.isEnabled = json["isEnabled"] as? Bool ?? true
        self.descripcion = json["descripcion"] as? String
        self.fechaGasto = (json["fechaGasto"] as? String)?.toDate(formato: formatoDeFecha.fecha)
        self.fechaCreacion = (json["fechaCreacion"] as? String)?.toDate(formato: formatoDeFecha.fechaConHora)
        self.importe = json["importe"] as? Double
    }
}


class ProfileViewModelRegistrosGastosItem: IORubrosProfileItem {
    var type: IORubrosProfileType {
        return .registros
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return registros.count
    }
    
    var registros: [IORegistroGastos]
    
    init(registros: [IORegistroGastos]) {
        self.registros = registros
    }
}


class ProfileViewModelBotonAgregarRegistroItem: IORubrosProfileItem {
    var type: IORubrosProfileType {
        return .botonAgregarRegistro
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
}
