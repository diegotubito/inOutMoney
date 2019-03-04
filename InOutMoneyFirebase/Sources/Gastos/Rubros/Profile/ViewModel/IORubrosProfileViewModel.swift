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
    /*
    func loadData() {

        let mes = model.fechaSeleccionada.mes
        let año = model.fechaSeleccionada.año
        let keyFechaString = MESES[mes]! + String(año)
        
        let path = UserID! + "/gastos/profiles/" + model.rubroRecibido.childID! + "/registros/" + keyFechaString
        
        MLFirebaseDatabaseService.retrieveData(path: path) { (response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error desconocido")
                return
            }
            
           
            
            let profile = Profile(data: response ?? [:])
            var registros = profile!.registros
            
            //filtro los registro
            registros = self.filtarRegistros(registros: registros)
            
            //una vez cargado los datos, los ordeno
            registros = registros.sorted(by: { $0.fechaCreacion? .compare($1.fechaCreacion!) == ComparisonResult.orderedDescending})
            
            self.model.registrosGastos = registros
            
            self.model.items.removeAll()
            //agrego el header

            let headerInfo = ProfileViewModelRubrosHeaderItem(mes: self.getNombreMes(), total: self.getTotal(), rubro: self.model.rubroRecibido.descripcion!)
             self.model.items.append(headerInfo)
            
            //agrego el boton agregar
            let botonItem = ProfileViewModelBotonAgregarRegistroItem()
            self.model.items.append(botonItem)
            
            
            //agrego los registros de los gastos realizados
       /*
             if !profile!.registros.isEmpty {
                let friendsItem = ProfileViewModelRegistrosGastosItem(registros: registros)
                self.model.items.append(friendsItem)
            }
         */
            
            let mes = String(self.model.fechaSeleccionada.mes)
            let año = String(self.model.fechaSeleccionada.año)
            let maxDays = self.model.fechaSeleccionada.endDay()
            var fechaInicial = (String(maxDays) + "-" + mes + "-" + año).toDate(formato: "dd-MM-yyyy")
            for _ in 1...maxDays - 1 {
                
                let resultArray = registros.filter {$0.fechaGasto == fechaInicial}
                
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
    }

    */
    
    func loadData() {
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
    
}


