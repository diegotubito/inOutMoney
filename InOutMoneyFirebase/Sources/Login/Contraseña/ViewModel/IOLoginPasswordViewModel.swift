//
//  IOLoginPasswordViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        if model.numberOfTries > 1 {
            _view.showLoading()
            _interactor.signInWithEmail(email: model.user, password: model.password, success: { (usuario) in
                self._view.hideLoading()
                self._view.showSuccess()
            }) { (error) in
                self._view.hideLoading()
         
                switch error {
                case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
                    print("wrong password")
                    self._view.showError(message: "")
                     break
            
                case .some( _):
                    self._view.showBlockingError()
                    print("blocking error \(String(describing: error?.localizedDescription))")
                    break
                case .none:
                    break
                }
                
            }
 
        
            
        } else {
            _view.showBlockingError()
        }
 
    }
    
    func setPassword(value: String) {
        model.password = value
    }
    
    func getUser() -> String {
        return model.user
    }
    func getNumberOfTries() -> String {
        return String(model.numberOfTries)
    }
    
    func descontarNumberOfTries() {
        model.numberOfTries -= 1
        _view.showNumberOfTries()
        _view.fadeNumberOfTries()
        
    }
    
    func getBackgroundColorNumberOfTries() -> UIColor {
        let value = model.numberOfTries
        if value == 3 {
            return UIColor.green
        } else if value == 2 {
            return UIColor.yellow
        } else {
            return UIColor.red
        }
    }
    
    func getTextColorNumberOfTries() -> UIColor {
        let value = model.numberOfTries
        if value == 3 {
            return UIColor.black
        } else if value == 2 {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
}
