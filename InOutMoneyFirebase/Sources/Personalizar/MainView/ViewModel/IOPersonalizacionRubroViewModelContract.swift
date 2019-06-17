//
//  IOPersonalizacionViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 17/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol IOPersonalizacionRubroViewModelContract {
    init(withView view: IOPersonalizacionRubroViewContract, service: MLFirebaseDatabase)
    
    var model : IOPersonalizacionRubroModel! {get}
    func cargarRubros()
    func eliminarRubro(row: Int)

}

protocol IOPersonalizacionRubroViewContract {
    func updateTableView()
    func showLoading()
    func hideLoading()
}
