//
//  IOAltaRubroViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOAltaRubroViewModel: IOAltaRubroViewModelContract {
    var _view : IOAltaRubroViewContract!
    var model: IOAltaRubroModel!
    
    
    required init(withView view: IOAltaRubroViewContract) {
        _view = view
        model = IOAltaRubroModel()
    }
    
    
    
}
