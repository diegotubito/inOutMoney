//
//  IORubrosProfileViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IORubrosProfileViewModelContract {
    init(withView view: IORubrosProfileViewContract, rubroSeleccionado: IORubroManager.Rubro, fechaSeleccionada: Date)
    var model : IORubrosProfileModel! {get set}

    func loadData()
     func getNombreMes() -> String
     func sumarMesFechaSeleccionada()
    func restarMesFechaSeleccionada()
    
     func deshabilitarRubro()
    func habilitarRubro()

    
}

protocol IORubrosProfileViewContract {
    func reloadList()
    func showToast(message: String)
    func showFechaSeleccionada()
       
}
