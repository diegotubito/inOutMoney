//
//  IOLoginPasswordViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IOLoginPasswordViewModelContract {
    init(withView view: IOLoginPasswordViewContract, interactor: IOLoginFirebaseService, user: String)
    
    func login()
    func getUser() -> String
}

protocol IOLoginPasswordViewContract {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func showSuccess()
    func disableLogin()
    func enableLogin()
    func getPassword() -> String

}
