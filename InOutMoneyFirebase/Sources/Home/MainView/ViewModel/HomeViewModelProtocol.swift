//
//  HomeViewModelProtocol.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {
    init(withView view: HomeViewProtocol)
    var model : HomeModel! {get}
}

protocol HomeViewProtocol {
    func reloadList()
}
