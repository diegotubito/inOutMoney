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
        
        //creo el header de cuentas
        let headerCuentas = HomeProfileViewModelOwnHeaderItem(keyName: "cuentaHeader", title: "TUS CUENTAS")
        model.items.append(headerCuentas)
        
        
        //creo las cuentas
        let cuentas = IOCuentaManager.cuentas
        if !cuentas.isEmpty {
            let cuentasItem = HomeProfileViewModelCuentasItem(cuentas: cuentas)
            model.items.append(cuentasItem)
        }
        
        //creo el header de rubros gastos
        let headerRubroGasto = HomeProfileViewModelOwnHeaderItem(keyName: "rubroGastoHeader", title: "RUBRO GASTOS")
        model.items.append(headerRubroGasto)
        
        //creo los rubros
        let rubros = IORubroManager.rubros
        if !rubros.isEmpty {
            let rubrosItem = HomeProfileViewModelRubrosItem(rubros: rubros)
            model.items.append(rubrosItem)
        }
  
      
        
        
        _view.reloadList()
    }
    
    
    func setRubroSeleccionado(index: Int) {
        model.rubroSeleccionado = IORubroManager.rubros[index]
        _view.goToProfileRubro()
    }
}

class HomeProfileViewModelCuentasItem: HomeProfileViewModelItem {
    var type: HomeProfileItemType {
        return .cuentas
    }
    
    var sectionTitle: String {
        return ""
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
        return ""
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


class HomeProfileViewModelOwnHeaderItem: HomeProfileViewModelItem {
    var type: HomeProfileItemType {
        return .ownHeader
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var title: String
    var keyName : String
    
    init(keyName: String, title: String) {
        self.title = title
        self.keyName = keyName
    }
}
