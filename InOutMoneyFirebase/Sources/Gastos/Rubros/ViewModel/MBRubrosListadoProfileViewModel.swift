//
//  MBProductoListadoViewModelContract.swift
//  contractExample
//
//  Created by David Diego Gomez on 23/12/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol IOGastosViewModelContract {
    init(withView view: IOGastosViewContract)
    func loadData()
}

protocol IOGastosViewContract {
    func reloadList()
}

enum ProfileViewModelItemType {
    case rubros
}

protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class ProfileViewModel: NSObject, IOGastosViewModelContract {
    var items = [ProfileViewModelItem]()
    var _view : IOGastosViewContract!
    
    required init(withView view: IOGastosViewContract) {
        _view = view
    }
    
    func loadData() {
        MLFirebaseDatabaseService.retrieveData(path: UserID!) { (response, error) in
            
            if error != nil {
                print("error")
                return
            }
            
            if response == nil {
                print("vacio")
                return
            }
            
            guard let profile = Profile(data: response!) else {
                return
            }
            let rubros = profile.rubros
            if !profile.rubros.isEmpty {
                let rubrosItem = ProfileViewModeRubrosItem(rubros: rubros)
                self.items.append(rubrosItem)
            }
            
            
        }
    }
    
}



class ProfileViewModeRubrosItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .rubros
    }
    
    var sectionTitle: String {
        return "Rubros"
    }
    
    var rowCount: Int {
        return rubros.count
    }
    
    var rubros: [Rubro]
    
    init(rubros: [Rubro]) {
        self.rubros = rubros
    }
}
