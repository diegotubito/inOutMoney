//
//  IOAltaIngresoViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 1/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IOAltaIngresoViewModelContract {
    init(withView view: IOAltaIngresoViewContract, rubroSeleccionado: IOProjectModel.Rubro, cuentas: [IOProjectModel.Cuenta])
    var model : IOAltaIngresoModel! {get set}
    
    func saveData()
    func set_cuenta_selected_index(_ value: Int?)
    func check_accounts()
    func getDescriptionArray() -> [String]
    func getAmountArray() -> [Double]
    func getCodeArray() -> [String]
    func getDescriptionAndAmountArray() -> [String] 
}

protocol IOAltaIngresoViewContract {
    func showSuccess()
    func showError(_ messagge: String)
    func getDescripcionTextField() -> String
    func getMontoTextField() -> String
    func getFechaTextField() -> String
}
