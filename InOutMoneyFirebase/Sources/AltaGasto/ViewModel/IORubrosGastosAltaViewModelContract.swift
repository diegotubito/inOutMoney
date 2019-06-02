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
    init(withView view: IORubrosGastosAltaViewContract, rubroSeleccionado: IORubroManager.Rubro)
     var model : IOAltaGastoModel! {get set}
    
    func saveData()
    func set_cuenta_selected_index(_ value: Int?)
    func check_accounts()
    
}

protocol IORubrosGastosAltaViewContract {
    func showSuccess()
    func showError(_ messagge: String)
    func getDescripcionTextField() -> String
    func getMontoTextField() -> String
    func getFechaTextField() -> String
}
