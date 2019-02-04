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

class IOLoginUsuarioViewModel: IOLoginUserViewModelContract {
    
    
 
    
    var _view : IOLoginUserViewContract!
    var _interactor : IOLoginFirebaseServiceContract!
    var model : IOLoginUserModel!
    
    
    required init(withView view: IOLoginUserViewContract, interactor: IOLoginFirebaseServiceContract, user: String) {
            _view = view
            _interactor = interactor
            model = IOLoginUserModel()
            model.user = user
              
    }
    
 
    func checkUser() {
        _view.showLoading()
        _interactor.getUserByEmail(email: _view.getEmailString(), success: { (response) in
            self._view.showSuccess(usuario: response!)
            self._view.hideLoading()
        }) { (error) in
            self._view.hideLoading()
            
            self._view.showError(message: error?.localizedDescription ?? "unknown error.")

        }
    }
    
    func logout() {
        _interactor.signOut(success: {
            print("log out")
        }) {
            print("error logging out")
        }
    }
    
    func getUser() -> String {
        return model.user
    }
}
