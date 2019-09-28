//
//  HomeModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class HomeModel {
    var rubros : [IOProjectModel.Rubro]?
    var cuentas : [IOProjectModel.Cuenta]?
    var registrosMesActual : [IOProjectModel.Registro]?
    var registrosMesAnterior : [IOProjectModel.Registro]?
    var registrosMesAnteriorAnterior : [IOProjectModel.Registro]?
    
    var todosLosRegistros : [IOProjectModel.Registro]?
    
    var nombreMesActual : String!
    var nombreMesAnterior : String!
    var nombreMesAnteriorAnterior : String!
    
    var fechaActual = Date()
}


