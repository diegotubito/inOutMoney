//
//  IOMovimientoViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IOMovimientoViewModel: IOMovimientoViewModelContract {
    var _view : IOMovimientoViewContract!
    var model : IOMovimientoModel!
    var _service : MLFirebaseDatabase!
    
    required init(withView view: IOMovimientoViewContract, service: MLFirebaseDatabase) {
        self._view = view
        self.model = IOMovimientoModel()
        self._service = service
    }
    
    func cargarRegistros() {
        let path = UserID! + ProjectConstants.firebaseSubPath.registros
        _view.showLoading()
        _service.fetch(path: path, completion: { (registros: [IOProjectModel.Registro]?) in
            self._view.hideLoading()
            if registros != nil {
                let sortedArray = registros!.sorted(by: { $0.fechaCreacion! > $1.fechaCreacion! })
                
                self.transformToSections(registros: sortedArray)
            }
            self._view.showSuccess()
        }) { (error) in
            self._view.hideLoading()
            self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
    }
    
    private func transformToSections(registros: [IOProjectModel.Registro]) {
        model.registros.removeAll()
        
        for i in registros {
            if let fecha = i.fechaCreacion?.prefix(10) {
                if !existeFecha(fecha: String(fecha)) {
                    let array = registros.filter({$0.fechaCreacion?.prefix(10) == fecha})
                    model.registros.append(array)
                }
            }
            
        }
    }
    
    private func existeFecha(fecha: String) -> Bool {
        for i in model.registros {
            for a in i {
                if let fechaComparable = a.fechaCreacion {
                    if fechaComparable.prefix(10) == fecha {
                        return true
                    }
                }
            }
        }
        return false
    }
    
}
