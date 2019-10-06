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
    
    
    required init(withView view: IOAltaEdicionRubroViewContract, selectedRegister: IOProjectModel.Rubro?) {
        _view = view
        model = IOAltaEdicionRubroModel()
        model.receivedRegister = selectedRegister
    }
    
    func editarRubro(descripcion: String) {
        if let errorMessage = validationErrorMessage() {
            _view.showWarning(errorMessage)
            return
        }
        
        var dato = parseData(descripcion: descripcion)
        dato.removeValue(forKey: ProjectConstants.KeyNames.Rubro.fechaCreacion)
        dato.removeValue(forKey: ProjectConstants.KeyNames.Rubro.isEnabled)
        
        let path = UserID! + ProjectConstants.firebaseSubPath.rubros + "/" + model.receivedRegister!.key
        
        MLFirebaseDatabase.update(path: path, diccionario: dato, success: { (ref) in
            NotificationCenter.default.post(name: .updateRubros, object: nil)
            self._view.success()
            
        }) { (error) in
             self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
    }
    
    func isForEdition() -> Bool {
        if model.receivedRegister == nil {
            return false
        }
        return true
    }
    
    func parseData(descripcion: String) -> [String : Any] {
        let dato = [ProjectConstants.KeyNames.Rubro.descripcion : descripcion,
                        ProjectConstants.KeyNames.Rubro.fechaCreacion : Date().toString(formato: formatoDeFecha.fechaConHora),
                        ProjectConstants.KeyNames.Rubro.fechaCreacionDouble : Date().timeIntervalSince1970,
                        ProjectConstants.KeyNames.Rubro.isEnabled : true,
                        ProjectConstants.KeyNames.Rubro.type : get_selected_type_code() ?? ""] as [String : Any]
        
        return dato
    }
    
    func guardarNuevoRubro(descripcion: String) {
        if let errorMessage = validationErrorMessage() {
            _view.showWarning(errorMessage)
            return
        }
        
        let dato = parseData(descripcion: descripcion)
        
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
        if model.receivedRegister != nil {
            _view.showTitle(title: "Editar Rubro")
        } else {
            _view.showTitle(title: "Nuevo Rubro")
        }
    }
    
    func getDataForEdition() {
        _view.showDescription(model.receivedRegister?.descripcion ?? "")
        let type = (model.receivedRegister?.type)!.uppercased()
        if  type == "_GAS" {
            model.type_selected_index = 0
        } else {
            model.type_selected_index = 1
        }
        _view.showPickerSelection()
    }
    
    func validationErrorMessage() -> String? {
        let descripcionText = _view.getDescriptionCell()
        
        if descripcionText.count == 0 {
            return "El campo Descripción no puede estar vacío."
        }

        if descripcionText.count > 30 {
            return "El campo Descripción no puede superar los 30 caracteres."
        }
        return nil
    }
    
}
