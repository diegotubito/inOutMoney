//
//  IORubrosGastosAltaModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 23/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IORubrosGastosAltaModel {
    var rubroSeleccionado : IORubrosListadoModel.rowData
    var codigoCuentaSeleccionada : Int = 0
    
    init(rubroRecibido: IORubrosListadoModel.rowData) {
        self.rubroSeleccionado = rubroRecibido
    }
}
