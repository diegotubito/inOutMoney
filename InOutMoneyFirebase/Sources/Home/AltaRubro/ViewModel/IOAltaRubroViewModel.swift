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
        let dato = ["descripcion" : descripcion,
                    "fechaCreacion" : Date().toString(formato: formatoDeFecha.fechaConHora)]
        
        MLFirebaseDatabaseService.setDataWithAutoId(path: UserID! + "/gastos/rubros", diccionario: dato, success: { (response) in
            self._view.success()
        }) { (error) in
            self._view.showError(error?.localizedDescription ?? "error")
        }
    }

}
