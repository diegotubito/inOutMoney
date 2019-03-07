//
//  IOMoverRegistroGastoViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 7/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IOMoverRegistroGastoViewModelContract {
    init(withView view: IOMoverRegistroGastoViewContract, rubroSeleccionado: IORubroManager.Rubro)
    var model : IOMoverRegistroGastoModel! {get set}
    func loadData()
    func moverRegistros()
    func setRubroSeleccionado(_ valor: Int)
    func filtrarRubrosDisponibles()
    func seleccionarRubroPorDefecto()
}


protocol IOMoverRegistroGastoViewContract {
    func reloadList()
    func showSuccess()
    func showError(message: String)
}

