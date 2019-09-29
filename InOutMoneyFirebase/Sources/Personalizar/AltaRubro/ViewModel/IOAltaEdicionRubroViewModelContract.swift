//
//  IOAltaRubroViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IOAltaEdicionRubroViewModelContract {
    init(withView view: IOAltaEdicionRubroViewContract, isEdition: Bool)
    var model : IOAltaEdicionRubroModel! {get set}
    func guardarNuevoRubro(descripcion: String)
    func getTitle()
    func set_type_selected_index(_ value: Int?)
    func validate() -> Bool
   }

protocol IOAltaEdicionRubroViewContract {
    func showError(_ message: String) 
    func success()
    func showTitle(title: String)
    func getDescriptionCell() -> String
    func showWarning(_ message: String)
}
