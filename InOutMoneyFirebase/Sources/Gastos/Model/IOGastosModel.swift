//
//  IOGastosModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 12/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOGastosProfile {
    var mes : Int
    var totalMensual : Double
    var rubros = [IOGastosRubro]()
    var nuevoRubro = [IOGastosNuevoRubro]()
    
    init(json: [String: Any]?) {
        self.mes = mesDeLaFecha(fecha: Date())
        self.totalMensual = 0
    }
}

class IOGastosRubro {
    var titulo : String
    var imagen_url : String
    var totalRubro : Double
    
    init(titulo: String, imagen_url: String, totalRubro: Double) {
        self.titulo = titulo
        self.imagen_url = imagen_url
        self.totalRubro = totalRubro
    }
}

class IOGastosNuevoRubro {
    var tituloBoton : String
    var imagenBoton : UIImage
    
    init(tituloBoton: String, imagenBoton: UIImage) {
        self.tituloBoton = tituloBoton
        self.imagenBoton = imagenBoton
    }
}
