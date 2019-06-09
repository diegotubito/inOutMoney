//
//  IOAltaIngresoModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 1/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation


class IOAltaIngresoModel {
    var rubroSeleccionado : IOProjectModel.Rubro
    var cuenta_selected_index : Int?
    var cuentas : [IOProjectModel.Cuenta]
    
    init(rubroRecibido: IOProjectModel.Rubro, cuentas: [IOProjectModel.Cuenta]) {
        self.rubroSeleccionado = rubroRecibido
        self.cuentas = cuentas
    }
}
