//
//  IOHomeModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 16/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

enum HomeProfileItemType {
    case cuentas
    case entradaSalida
    case rubroGasto
    case rubroIngreso
    case ownHeader
}

protocol HomeProfileViewModelItem {
    var type: HomeProfileItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class IOHomeModel {
    var items = [HomeProfileViewModelItem]()
    var periodoSeleccionado = Date()
    var rubroSeleccionado : IORubroManager.Rubro?
    
}
