//
//  IOAltaRubroViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IOAltaEdicionRubroViewModelContract {
    init(withView view: IOAltaEdicionRubroViewContract, selectedRegister: IOProjectModel.Rubro?)
    var model : IOAltaEdicionRubroModel! {get set}
    func guardarNuevoRubro(descripcion: String)
    func editarRubro(descripcion: String)
    func isForEdition() -> Bool
    func getTitle()
    func set_type_selected_index(_ value: Int?)
    func getDataForEdition() 
   }

protocol IOAltaEdicionRubroViewContract {
    func showError(_ message: String) 
    func success()
    func showTitle(title: String)
    func getDescriptionCell() -> String
    func showWarning(_ message: String)
    func showDescription(_ message: String)
    func showPickerSelection()
}
