//
//  IOLoginUsuarioViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IOLoginUsuarioViewModelContract {
    init(withView view: IOLoginUsuarioViewContract, interactor: IOLoginFirebaseServiceContract)
    
    func checkUser()
    func setEmail(value: String)
  
}

protocol IOLoginUsuarioViewContract {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func showSuccess(usuario: [String])
    func disableSiguiente()
    func enableSiguiente()

}
