//
//  IONuevoUsuarioViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IONuevoUsuarioViewModelContract {
    init(withView view: IONuevoUsuarioViewContract, interactor: IOLoginFirebaseService)
    
    func registerNewUser()
    func getModel() -> IONuevoUsuarioModel
    func setEmail(value: String)
    func getEmail() -> String
    func setPassword(value: String)
    func getPassword() -> String
    func setPasswordRepetition(value: String)
    func getPasswordRepetition() -> String

}

protocol IONuevoUsuarioViewContract {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showSuccess(_ message: String)
}
