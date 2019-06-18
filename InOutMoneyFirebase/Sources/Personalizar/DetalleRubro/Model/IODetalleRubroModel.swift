//
//  IODetalleRubroModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 17/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IODetalleRubroModel {
    var rubroSeleccionado : IOProjectModel.Rubro
    var registros = [[IOProjectModel.Registro]]()
    
    init(rubro: IOProjectModel.Rubro) {
        self.rubroSeleccionado = rubro
    }
}
