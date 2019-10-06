//
//  IODetalleRubroViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 17/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IODetalleRubroViewModel: IODetalleRubroViewModelContract {
    var _view : IODetalleRubroViewContract!
    var _service : MLFirebaseDatabase!
    var model : IODetalleRubroModel!
    
    required init(withView view: IODetalleRubroViewContract, service: MLFirebaseDatabase, rubroSeleccionado: IOProjectModel.Rubro) {
        _view = view
        _service = service
        model = IODetalleRubroModel(rubro: rubroSeleccionado)
    }
    
    func cargarRegistros() {
        
        model.registros.removeAll()
        
        let path = UserID! + ProjectConstants.firebaseSubPath.registros
        let queryKey = "childIDRubro"
        let queryValue = model.rubroSeleccionado.key
        _view.showLoading()
        _service.fetchWithQuery(path: path, keyName: queryKey, value: queryValue, completion: { (registros: [IOProjectModel.Registro]?) in
            if registros != nil {
                let sortedArray = registros!.sorted(by: { $0.fechaCreacionDouble ?? 0.0 > $1.fechaCreacionDouble ?? 0.0 })
                
                self.transformToSections(registros: sortedArray)
                self._view.updateTableView()
            }
            self._view.hideLoading()
        }) { (error) in
            self._view.hideLoading()
            self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
    }
    
    
    private func transformToSections(registros: [IOProjectModel.Registro]) {
        model.registros.removeAll()
        
        for i in registros {
        
            if !existeFecha(query: i.queryByMonthYear!) {
                let array = registros.filter({$0.queryByMonthYear == i.queryByMonthYear})
                model.registros.append(array)
            }
            
        }
    }
    
    private func existeFecha(query: String) -> Bool {
        for i in model.registros {
            for a in i {
                if a.queryByMonthYear == query {
                    return true
                }
            }
        }
        return false
    }
    
}
