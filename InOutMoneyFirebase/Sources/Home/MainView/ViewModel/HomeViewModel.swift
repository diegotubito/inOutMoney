//
//  HomeViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class HomeViewModel : HomeViewModelProtocol {
    var model: HomeModel!
    var _view : HomeViewProtocol!
    
    required init(withView view: HomeViewProtocol) {
        _view = view
        model = HomeModel()
    }
    
    
}
