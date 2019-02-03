//
//  IOLoginUsuarioViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class IOLoginUsuarioViewModel: IOLoginUsuarioViewModelContract {
    
 
    
    var _view : IOLoginUsuarioViewContract!
    var _interactor : IOLoginFirebaseServiceContract!
    var model : IOLoginModel!
    
    
    required init(withView view: IOLoginUsuarioViewContract, interactor: IOLoginFirebaseServiceContract) {
            _view = view
            _interactor = interactor
        model = IOLoginModel()
    }
    
 
    func checkUser() {
        _interactor.getUserByEmail(email: model.user, success: { (response) in
            self._view.showSuccess(usuario: response!)
            
        }) { (message) in
            self._view.showError(message: message ?? "unknown error.")

        }
    }
    
    func setEmail(value: String) {
        model.user = value
    }
    
   
    
}
