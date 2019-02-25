//
//  IORubrosProfileViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IORubrosProfileViewModelContract {
    init(withView view: IORubrosProfileViewContract, rubroSeleccionado: IORubrosListadoModel.rowData)
    var model : IORubrosProfileModel! {get set}

    func loadData()
    func getTotal() -> Double
    func getNombreMes() -> String
    func filtarRegistros(registros: [IORegistroGastos]) -> [IORegistroGastos]
    func sumarMesFechaSeleccionada()
    func restarMesFechaSeleccionada()
    
}

protocol IORubrosProfileViewContract {
    func reloadList()
    func showToast(message: String)
    func showFechaSeleccionada()
}
