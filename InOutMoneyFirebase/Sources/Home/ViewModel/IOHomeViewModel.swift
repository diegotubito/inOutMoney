//
//  IOHomeViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 14/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOHomeViewModel: IOHomeViewModelContract {
    var _view : IOHomeViewContract!
    var model : IOHomeModel!
    
    required init(withView view: IOHomeViewContract) {
        _view = view
        model = IOHomeModel()
    }
    
    func getDataFromFirebase(path: String) {
        
        MLFirebaseDatabaseService.retrieveData(path: path) { (response, error) in
            if error != nil {
                self._view.toast(message: (error?.localizedDescription)!)
                return
            }
            
            if response == nil {
                self._view.toast(message: "No hay registros en Firebase.")
                return
            }
            
            print(response!)
        }
    }
}
