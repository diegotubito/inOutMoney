//
//  IOHomeViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 14/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
protocol IOHomeViewModelContract {
    init(withView view: IOHomeViewContract)
    func crearItems()
    func setRubroSeleccionado(index: Int)
}

protocol IOHomeViewContract {
    func toast(message: String)
    func reloadList()
    func goToProfileRubro()
}
