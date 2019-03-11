//
//  IODetalleRegistroGastoModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IODetalleRegistroGastoModel {
    var registroRecibido: IORegistroManager.Registro
    var indexCuentaSeleccionada : Int = 0
    
    
    init(registroRecibido: IORegistroManager.Registro) {
        self.registroRecibido = registroRecibido
    }
}
