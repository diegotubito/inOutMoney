//
//  IOLoginPasswordViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOLoginPasswordViewModel: IOLoginPasswordViewModelContract {
   
    var _view : IOLoginPasswordViewContract!
    var _interactor : IOLoginFirebaseService!
    var model : IOLoginPasswordModel!
    
    required init(withView view: IOLoginPasswordViewContract, interactor: IOLoginFirebaseService, user: String) {
        _view = view
        _interactor = interactor
        
        model = IOLoginPasswordModel()
        model.user = user
        
    }
    
    func login() {
        
        model.password = _view.getPassword()
        
        _interactor.signInWithEmail(email: model.user, password: model.password, success: { (usuario) in
            self._view.showSuccess()
        }) { (errorMessage) in
             self._view.showError(message: errorMessage ?? "unknown error.")
        }
    }
    
    func setPassword(value: String) {
        model.password = value
    }
    
    func getUser() -> String {
        return model.user
    }
    
    
}
