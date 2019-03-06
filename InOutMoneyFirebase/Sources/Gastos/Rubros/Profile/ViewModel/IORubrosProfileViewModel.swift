//
//  IORubrosProfileViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IORubrosProfileViewModel: IORubrosProfileViewModelContract {
    
    
    
    
    var _view : IORubrosProfileViewContract!
    var model : IORubrosProfileModel!
    
    required init(withView view: IORubrosProfileViewContract, rubroSeleccionado: IORubroManager.Rubro, fechaSeleccionada: Date) {
        _view = view
        model = IORubrosProfileModel(rubro: rubroSeleccionado, fechaSeleccionada: fechaSeleccionada)
         
    }
    
    func loadData() {
        model.items.removeAll()
        
        let headerInfo = ProfileViewModelRubrosHeaderItem(mes: MESES[model.fechaSeleccionada.mes]!, total: IORegistroManager.getTotal(childIDRubro: model.rubroRecibido.childID), rubro: self.model.rubroRecibido.descripcion)
        self.model.items.append(headerInfo)
        
        //agrego el boton agregar
        let botonItem = ProfileViewModelBotonAgregarRegistroItem()
        self.model.items.append(botonItem)
        
        //registros
        if IORegistroManager.registros.count == 0 {return}
        
        let fecha = model.fechaSeleccionada
        let mes = String(fecha.mes)
        let año = String(fecha.año)
        let maxDays = fecha.endDay()
        var fechaInicial = (String(maxDays) + "-" + mes + "-" + año).toDate(formato: "dd-MM-yyyy")
        for _ in 1...maxDays - 1 {
            
            let resultArray = IORegistroManager.registros.filter {$0.fechaGasto == fechaInicial && $0.childIDRubro == model.rubroRecibido.childID}
            
            if resultArray.count > 0 {
                let fechaItem = ProfileViewModelFechaGastosItem(fecha: fechaInicial!)
                self.model.items.append(fechaItem)
                
                let registrosItem = ProfileViewModelRegistrosGastosItem(registros: resultArray)
                self.model.items.append(registrosItem)
                
            }
            
            fechaInicial = Calendar.current.date(byAdding: .day, value: -1, to: fechaInicial!)
        }
        self._view.reloadList()
    }
    
  
    
    func getNombreMes() -> String {
        return model.fechaSeleccionada.nombreDelMes
    }
    
    func sumarMesFechaSeleccionada() {
        model.fechaSeleccionada.sumarMes(valor: 1)
        _view.showFechaSeleccionada()
    }
    
    func restarMesFechaSeleccionada() {
        model.fechaSeleccionada.sumarMes(valor: -1)
        _view.showFechaSeleccionada()
    }
    
    
    
    func deshabilitarRubro() {
        let childID = model.rubroRecibido.childID
        
        let dato = ["isEnabled" : false]
        
        MLFirebaseDatabaseService.update(path: UserID! + "/gastos/rubros/" + childID, diccionario: dato, success: { (response) in
            self._view.showToast(message: "Rubro deshabilitado.")
        }) { (error) in
            self._view.showToast(message: error?.localizedDescription ?? "No se pudo deshabilitar rubro.")
        }
    }
    
    func habilitarRubro() {
        let childID = model.rubroRecibido.childID
        
        let dato = ["isEnabled" : true]
        
        MLFirebaseDatabaseService.update(path: UserID! + "/gastos/rubros/" + childID, diccionario: dato, success: { (response) in
            self._view.showToast(message: "Rubro habilitado.")
        }) { (error) in
            self._view.showToast(message: error?.localizedDescription ?? "No se pudo habilitar rubro.")
        }
    }
    
    
}


