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
    case fecha
    case registros
}

class IORubrosProfileModel {
    var rubroRecibido : IORubroManager.Rubro
    var items = [IORubrosProfileItem]()
    var fechaSeleccionada = Date()
    
    init(rubro: IORubroManager.Rubro, fechaSeleccionada: Date) {
        self.rubroRecibido = rubro
        self.fechaSeleccionada = fechaSeleccionada
        
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
    
    var registros: [IORegistroManager.Registro]
    
    init(registros: [IORegistroManager.Registro]) {
        self.registros = registros
    }
}

class ProfileViewModelFechaGastosItem: IORubrosProfileItem {
    var type: IORubrosProfileType {
        return .fecha
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var fecha: Date?
    
    init(fecha: Date) {
        self.fecha = fecha
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
