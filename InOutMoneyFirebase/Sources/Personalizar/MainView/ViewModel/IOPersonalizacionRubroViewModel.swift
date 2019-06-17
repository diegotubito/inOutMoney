//
//  IOPersonalizacionViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 17/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOPersonalizacionRubroViewModel: IOPersonalizacionRubroViewModelContract {
    var _service : MLFirebaseDatabase!
    var _view : IOPersonalizacionRubroViewContract!
    var model : IOPersonalizacionRubroModel!
    
    required init(withView view: IOPersonalizacionRubroViewContract, service: MLFirebaseDatabase) {
        self._view = view
        self._service = service
        
        model = IOPersonalizacionRubroModel()
        
    }
    
    func cargarRubros() {
        model.rubros.removeAll()
        
        
        let path = UserID! + ProjectConstants.firebaseSubPath.rubros
        _view.showLoading()
        _service.fetch(path: path, completion: { (rubros: [IOProjectModel.Rubro]?) in
            if rubros != nil {
                let rubrosOrdenados = rubros?.sorted(by: {$0.descripcion < $1.descripcion})
                self.model.rubros = rubrosOrdenados!
                self._view.updateTableView()
            }
            self._view.hideLoading()
        }) { (error) in
            print(error?.localizedDescription ?? ProjectConstants.unknownError)
            self._view.hideLoading()
        }
        
    }
  
    func eliminarRubro(row: Int) {
        let rubro = model.rubros[row]
        let path = UserID! + ProjectConstants.firebaseSubPath.rubros + "/" + rubro.key
        
        MLFirebaseDatabase.delete(path: path) { (success, error) in
            guard error == nil else {
                return
            }
            
            NotificationCenter.default.post(name: .updateRubros, object: nil)
            self.cargarRubros()
        }
    }
}
