//
//  IOBorrarRubroGastoViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 6/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IOBorrarRubroGastoViewModelContract {
    init(withView view: IOBorrarRubroGastoViewContract, rubroSeleccionado: IORubroManager.Rubro)
    var model : IOBorrarRubroGastoModel! {get set}
    func loadData()
    func eliminarRubro() 
}


protocol IOBorrarRubroGastoViewContract {
    func reloadList()
    func showSuccess()
    func showError(message: String)
}
