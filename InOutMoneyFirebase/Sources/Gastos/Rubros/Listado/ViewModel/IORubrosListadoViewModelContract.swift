//
//  IORubrosListadoViewModelContract.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IORubrosListadoViewModelContract {
    init(withView view: IORubrosListadoViewContract)
    var model : IORubrosListadoModel! {get set}
    
    func loadData() 
}

protocol IORubrosListadoViewContract {
    func reloadList()
}
