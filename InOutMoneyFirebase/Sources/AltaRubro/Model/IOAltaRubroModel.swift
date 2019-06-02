//
//  IOAltaRubroModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IOAltaRubroModel {
    var type_selected_index : Int?
    
    struct KeyNames {
        //firebase keys
        static let descripcion = "descripcion"
        static let fechaCreacion = "fechaCreacion"
        static let isEnabled = "isEnabled"
        static let type = "type"
    }
}
