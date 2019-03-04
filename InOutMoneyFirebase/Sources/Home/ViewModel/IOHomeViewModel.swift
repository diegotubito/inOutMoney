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
    
    func crearItems() {
        model.items.removeAll()
        
        
        //creo la entrada y salida
        let entradaSalida = HomeProfileViewModelEntradaSalidaItem(periodo: model.periodoSeleccionado,
                                                                  totalGastos: IORegistroManager.getTotalRegistros(),
                                                                  totalIngresos: 0.0)
        model.items.append(entradaSalida)
        
        //creo los rubros
        let rubros = IORubroManager.rubros
        if !rubros.isEmpty {
            let rubrosItem = HomeProfileViewModelRubrosItem(rubros: rubros)
            model.items.append(rubrosItem)
        }
  
        //creo las cuentas
        let rubros = IORubroManager.rubros
        if !rubros.isEmpty {
            let rubrosItem = HomeProfileViewModelRubrosItem(rubros: rubros)
            model.items.append(rubrosItem)
        }
        
        
        _view.reloadList()
    }
    
    
 
}

class HomeProfileViewModelCuentasItem: HomeProfileViewModelItem {
    var type: HomeProfileItemType {
        return .cuentas
    }
    
    var sectionTitle: String {
        return "TUS CUENTAS"
    }
    
    var rowCount: Int {
        return cuentas.count
    }
    
    var cuentas: [IOCuentaManager.Cuenta]
    
    init(cuentas: [IOCuentaManager.Cuenta]) {
        self.cuentas = cuentas
    }
}


class HomeProfileViewModelRubrosItem: HomeProfileViewModelItem {
    var type: HomeProfileItemType {
        return .rubroGasto
    }
    
    var sectionTitle: String {
        return "RUBROS GASTOS"
    }
    
    var rowCount: Int {
        return rubros.count
    }
    
    var rubros: [IORubroManager.Rubro]
    
    init(rubros: [IORubroManager.Rubro]) {
        self.rubros = rubros
    }
}


class HomeProfileViewModelEntradaSalidaItem: HomeProfileViewModelItem {
    var type: HomeProfileItemType {
        return .entradaSalida
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var periodoSeleccionado: Date
    var totalGastos: Double
    var totalIngresos : Double
    
    init(periodo: Date, totalGastos: Double, totalIngresos: Double) {
        self.periodoSeleccionado = periodo
        self.totalGastos = totalGastos
        self.totalIngresos = totalIngresos
    }
}
