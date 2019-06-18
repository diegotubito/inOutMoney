//
//  IODetalleRubroViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 17/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IODetalleRubroViewModelContract {
    init(withView view: IODetalleRubroViewContract, service: MLFirebaseDatabase, rubroSeleccionado: IOProjectModel.Rubro)
    var model : IODetalleRubroModel! {get}
    
    func cargarRegistros()
}


protocol IODetalleRubroViewContract {
    func showLoading()
    func hideLoading()
    func updateTableView()
    func showError(_ message: String) 
}
