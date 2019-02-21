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
    var listado : [rowData] = [rowData]()
    
    class rowData {
        var childID : String?
        var descripcion : String?
        var fechaCreacion : Date?
        
        init(childID: String, descripcion: String, fechaCreacion: Date) {
            self.childID = childID
            self.descripcion = descripcion
            self.fechaCreacion = fechaCreacion
        }
    }
}
