//
//  IOAltaRubroViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOAltaEdicionRubroViewModel: IOAltaEdicionRubroViewModelContract {
  
    var _view : IOAltaEdicionRubroViewContract!
    var model: IOAltaEdicionRubroModel!
    
    
    required init(withView view: IOAltaEdicionRubroViewContract, isEdition: Bool) {
        _view = view
        model = IOAltaEdicionRubroModel()
        model.isEdition = isEdition
    }
    
    func guardarNuevoRubro(descripcion: String) {
        if !validate(){
            _view.showWarning("El campo Descripción no puede estar vacío.")
            return
        }
        
        let dato = [ProjectConstants.KeyNames.Rubro.descripcion : descripcion,
                    ProjectConstants.KeyNames.Rubro.fechaCreacion : Date().toString(formato: formatoDeFecha.fechaConHora),
                    ProjectConstants.KeyNames.Rubro.isEnabled : true,
                    ProjectConstants.KeyNames.Rubro.type : get_selected_type_code() ?? ""] as [String : Any]
        
        MLFirebaseDatabase.setDataWithAutoId(path: UserID! + ProjectConstants.firebaseSubPath.rubros, diccionario: dato, success: { (response) in
            
            NotificationCenter.default.post(name: .updateRubros, object: nil)
            
            self._view.success()
        }) { (error) in
            self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
    }
    
    func set_type_selected_index(_ value: Int?) {
        model.type_selected_index = value
    }
    
    func get_selected_type_code() -> String? {
        if let selected_index = model.type_selected_index {
            let keys = ProjectConstants.rubros.getKeys()
            return keys[selected_index]
        }
        return nil
    }
    
    func getTitle() {
        if model.isEdition {
            _view.showTitle(title: "Editar Rubro")
        } else {
            _view.showTitle(title: "Nuevo Rubro")
        }
    }
    
    func validate() -> Bool {
        let descripcionText = _view.getDescriptionCell()
        
        if descripcionText.count == 0 {
            return false
        }

        if descripcionText.count > 30 {
            return false
        }
        return true
    }
    
}
