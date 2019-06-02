//
//  IOAltaIngresoModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 1/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation


class IOAltaIngresoModel {
    var rubroSeleccionado : IORubroManager.Rubro
    var cuenta_selected_index : Int?
    
    init(rubroRecibido: IORubroManager.Rubro) {
        self.rubroSeleccionado = rubroRecibido
    }
    
    struct KeyNames {
        static let queryByTypeMonthYear = "queryByTypeMonthYear"
        static let queryByTypeYear      = "queryByTypeYear"
        static let queryByMonthYear     = "queryByMonthYear"
        static let queryByYear          = "queryByYear"
        static let childIDRubro         = "childIDRubro"
        static let isEnabled            = "isEnabled"
        static let childIDDebito        = "childIDDebito"
        static let descripcion          = "descripcion"
        static let fechaGasto           = "fechaGasto"
        static let fechaCreacion        = "fechaCreacion"
        static let importe              = "importe"
        static let type                 = "type"
        
    }
}
