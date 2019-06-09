//
//  IORubrosGastosAltaViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 23/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol IORubrosGastosAltaViewModelContract {
    init(withView view: IORubrosGastosAltaViewContract, rubroSeleccionado: IOProjectModel.Rubro, cuentas: [IOProjectModel.Cuenta])
     var model : IOAltaGastoModel! {get set}
    
    func saveData()
    func set_cuenta_selected_index(_ value: Int?)
    func check_accounts()
    func getDescriptionArray() -> [String]
    func getAmountArray() -> [Double]
    func getCodeArray() -> [String]
    func getDescriptionAndAmountArray() -> [String] 
    
}

protocol IORubrosGastosAltaViewContract {
    func showSuccess()
    func showError(_ messagge: String)
    func getDescripcionTextField() -> String
    func getMontoTextField() -> String
    func getFechaTextField() -> String
}
