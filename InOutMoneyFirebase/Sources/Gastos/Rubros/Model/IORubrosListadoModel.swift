//
//  MBRubrosListadoModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IORubrosListadoModel {
    var listado : [rowData]?
    
    class rowData {
        var descripcion : String?
        var fechaCreacion : Date?
        
        init(descripcion: String, fechaCreacion: Date) {
            self.descripcion = descripcion
            self.fechaCreacion = fechaCreacion
        }
    }
}
