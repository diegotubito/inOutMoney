//
//  IODetalleRegistroViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IODetalleRegistroGastoViewModelContract {
    init(withView view: IODetalleRegistroGastoViewContract, registroSeleccionado: IORegistroManager.Registro)
    var model : IODetalleRegistroGastoModel! {get}
    func eliminar()
    func guardarCambios()
}

protocol IODetalleRegistroGastoViewContract {
    func showError(_ mensaje: String)
    func showSuccess(_ mensaje: String)
    
    func getFechaInput() -> Date
    func getChildIDDebitoInput() -> String
    func getImporteInput() -> Double
    func getDescripcion() -> String
}
