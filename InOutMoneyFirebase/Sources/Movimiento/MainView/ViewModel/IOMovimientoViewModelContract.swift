//
//  IOMovimientoViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IOMovimientoViewModelContract {
    init(withView view: IOMovimientoViewContract, service: MLFirebaseDatabase)
    
    var model : IOMovimientoModel! {get}
    
    func cargarRegistros()
    func anularReestablecer(section: Int, row: Int, value: Int)
    func eliminarRegistro(section: Int, row: Int)
    func getFecha(section: Int) -> String
    func setColor(registro: IOProjectModel.Registro, cell: IOTableViewCellSingleLabel)
}


protocol IOMovimientoViewContract {
    func showError(_ errorMessage: String)
    func showSuccess()
    func showLoading()
    func hideLoading()
    func realoadList()

}
