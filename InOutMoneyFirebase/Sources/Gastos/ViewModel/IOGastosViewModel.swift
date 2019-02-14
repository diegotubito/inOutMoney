//
//  IOGastosViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 12/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

enum IOGastosViewModelProfileItemType {
    case header
    case rubros
    case estadistica
    case presupuesto
    case nuevoRubro
}

protocol IOGastosViewModelProfileItem {
    var type: IOGastosViewModelProfileItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class IOGastosViewModel: NSObject {
    var items = [IOGastosViewModelProfileItem]()
    
    override init() {
        super.init()
        
        //hardcode data, for testing purpose
          
        let profile = IOGastosProfile(json: nil)
        
        let headerItem = IOGastosViewModelProfileHeaderItem(mes: "ENERO", totalMensual: "$ 1.000,00")
        items.append(headerItem)
        
        let rubros = profile.rubros
        if !profile.rubros.isEmpty {
            let rubrosItems = IOGastosViewModelProfileRubrosItem(rubros: rubros)
            items.append(rubrosItems)
        }
    }
}


class IOGastosViewModelProfileHeaderItem: IOGastosViewModelProfileItem {
    var type: IOGastosViewModelProfileItemType {
        return .header
    }
    
    var sectionTitle: String {
        return "Header"
    }
    
    var rowCount: Int {
        return 1
    }
    
    var mes: String
    var totalMensual: String
    
    init(mes: String, totalMensual: String) {
        self.mes = mes
        self.totalMensual = totalMensual
    }
}


class IOGastosViewModelProfileRubrosItem: IOGastosViewModelProfileItem {
    var type: IOGastosViewModelProfileItemType {
        return .rubros
    }
    
    var sectionTitle: String {
        return "Rubros"
    }
    
    var rowCount: Int {
        return rubros.count
    }
    
    var rubros: [IOGastosRubro]
    
    init(rubros: [IOGastosRubro]) {
        self.rubros = rubros
    }
}
