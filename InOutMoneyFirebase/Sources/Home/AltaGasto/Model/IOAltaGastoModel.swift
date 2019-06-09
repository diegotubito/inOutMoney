//
//  IORubrosGastosAltaModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 23/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IOAltaGastoModel {
    var rubroSeleccionado : IOProjectModel.Rubro
    var cuenta_selected_index : Int?
    var cuentas : [IOProjectModel.Cuenta]
    
    init(rubroRecibido: IOProjectModel.Rubro, cuentas: [IOProjectModel.Cuenta]) {
        self.rubroSeleccionado = rubroRecibido
        self.cuentas = cuentas
    }
    
    
}
