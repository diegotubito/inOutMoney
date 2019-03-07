//
//  IOMoverRegistroGastoModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 7/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IOMoverRegistroGastoModel {
    var registros = [IORegistroManager.Registro]()
    var rubrosDisponibles = [IORubroManager.Rubro]()
    var rubroRecibido : IORubroManager.Rubro!
    var rubroElegido : Int?
    
    init(rubroRecibido: IORubroManager.Rubro) {
        self.rubroRecibido = rubroRecibido
    }
}
