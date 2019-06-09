//
//  IOAltaRubroViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOAltaRubroViewModel: IOAltaRubroViewModelContract {
  
    var _view : IOAltaRubroViewContract!
    var model: IOAltaRubroModel!
    
    
    required init(withView view: IOAltaRubroViewContract) {
        _view = view
        model = IOAltaRubroModel()
    }
    
    func guardarNuevoRubro(descripcion: String) {
        let dato = [ProjectConstants.KeyNames.Rubro.descripcion : descripcion,
                    ProjectConstants.KeyNames.Rubro.fechaCreacion : Date().toString(formato: formatoDeFecha.fechaConHora),
                    ProjectConstants.KeyNames.Rubro.isEnabled : true,
                    ProjectConstants.KeyNames.Rubro.type : get_selected_type_code() ?? ""] as [String : Any]
        
        MLFirebaseDatabase.setDataWithAutoId(path: UserID! + ProjectConstants.firebaseSubPath.rubros, diccionario: dato, success: { (response) in
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
    
}
