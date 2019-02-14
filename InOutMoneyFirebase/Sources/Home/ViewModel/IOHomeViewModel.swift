//
//  IOHomeViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 14/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOHomeViewModel: IOHomeViewModelContract {
    func getDataFromFirebase(path: String) {
        
        MLFirebaseDatabaseService.retrieveData(path: path) { (response, error) in
            if error != nil {
                print("error al cargar fecha \(String(describing: error?.localizedDescription))")
                return
            }
            
            print(response!)
        }
    }
}
