//
//  IOBorrarRubroGastoModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 6/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
class IOBorrarRubroGastoModel {
    var registros = [IORegistroManager.Registro]()
    var rubroRecibido : IORubroManager.Rubro!
    
    init(rubroRecibido: IORubroManager.Rubro) {
        self.rubroRecibido = rubroRecibido
    }
}
