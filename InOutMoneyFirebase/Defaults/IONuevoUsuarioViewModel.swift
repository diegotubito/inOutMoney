//
//  IONuevoUsuarioViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation


class IONuevoUsuarioViewModel : IONuevoUsuarioViewModelContract {
   
    
    var _view : IONuevoUsuarioViewContract
    var _interactor : IOLoginFirebaseService
    
    var model : IONuevoUsuarioModel
    
    required init(withView view: IONuevoUsuarioViewContract, interactor: IOLoginFirebaseService) {
        self._view = view
        self.model = IONuevoUsuarioModel()
        
        self._interactor = interactor
    }
    
    func validarCampos() -> String? {
        var valor : String?
        
        if model.email.isEmpty {
            valor = "Tienes que ingresar una cuenta de correo existente."
            return valor
        }
        if model.password.isEmpty {
            valor = "El campo Clave no puede estar vacio."
            return valor
        }
        if model.password.count < 6 {
            valor = "La clave no debe ser menor a 6 caracteres."
            return valor
        }
        if model.password != model.passwordRepetition {
            valor = "Las claves no coinciden."
            return valor
        }
        
        
        return valor
    }
    
    func registerNewUser() {
        
        if let message = validarCampos() {
            _view.showError(message)
            return
        }
    
        _view.showLoading()
        _interactor.registerNewUser(email: model.email, password: model.password, success: { (user) in
            self._view.hideLoading()
            self._view.showSuccess("Tu usuario fue creado con exito.")
        }) { (error) in
            self._view.hideLoading()
            self._view.showError(error.localizedDescription)
        }
    }
    
    func createUserInDataBase() {
        
    }
    
    func getModel() -> IONuevoUsuarioModel {
        return model
    }
    
    func setEmail(value: String) {
        model.email = value
    }
    
    func getEmail() -> String {
        return model.email
    }
    
    
    func setPassword(value: String) {
        model.password = value
    }
    
    func getPassword() -> String {
        return model.password
    }
    
    func setPasswordRepetition(value: String) {
        model.passwordRepetition = value
    }
    
    func getPasswordRepetition() -> String {
        return model.passwordRepetition
    }
    
    
    
    
}
