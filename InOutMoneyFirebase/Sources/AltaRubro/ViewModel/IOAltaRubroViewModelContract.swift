//
//  IOAltaRubroViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IOAltaRubroViewModelContract {
    init(withView view: IOAltaRubroViewContract)
    var model : IOAltaRubroModel! {get set}
    func guardarNuevoRubro(descripcion: String)
   }

protocol IOAltaRubroViewContract {
    func showError(_ message: String) 
    func success()
}
