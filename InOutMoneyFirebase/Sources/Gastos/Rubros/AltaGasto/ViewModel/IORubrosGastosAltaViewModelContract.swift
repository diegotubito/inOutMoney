//
//  IORubrosGastosAltaViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 23/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol IORubrosGastosAltaViewModelContract {
    init(withView view: IORubrosGastosAltaViewContract)
    func loadData()
    var model : IORubrosGastosAltaModel! {get set}
}

protocol IORubrosGastosAltaViewContract {
    
}
