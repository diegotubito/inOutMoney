//
//  IOLoginUsuarioViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IOLoginUserViewModelContract {
    init(withView view: IOLoginUserViewContract, interactor: IOLoginFirebaseServiceContract, user: String)
    
    func checkUser()
    func logout()
    func getUser() -> String
}

protocol IOLoginUserViewContract {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func showSuccess(usuario: [String])
    func getEmailString() -> String
    func goToPassword()
    

}
