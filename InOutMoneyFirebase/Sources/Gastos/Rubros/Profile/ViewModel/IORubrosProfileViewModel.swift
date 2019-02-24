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
    
    required init(withView view: IORubrosProfileViewContract, rubroSeleccionado: IORubrosListadoModel.rowData) {
        _view = view
        model = IORubrosProfileModel(rubro: rubroSeleccionado)
    
        
    }
    
    func loadData() {
        MLFirebaseDatabaseService.retrieveData(path: UserID! + "/gastos/profiles/" + model.rubroRecibido.childID!) { (response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error desconocido")
                return
            }
            
            if response == nil {
                print("no hay datos")
                return
            }
            
            print(response)
            let profile = Profile(data: response!)
            let registros = profile!.registros
            self.model.registrosGastos = registros
            
            //agrego el header

            let headerInfo = ProfileViewModelRubrosHeaderItem(mes: self.getNombreMes(), total: self.getTotal())
            self.model.items.append(headerInfo)
            
            //agrego el boton agregar
            let botonItem = ProfileViewModelBotonAgregarRegistroItem()
            self.model.items.append(botonItem)
            
            //agrego los registros de los gastos realizados
            
             if !profile!.registros.isEmpty {
                let friendsItem = ProfileViewModelRegistrosGastosItem(registros: registros)
                self.model.items.append(friendsItem)
            }
            
            
       
            
            self._view.reloadList()
            
            
        }
    }
    
    func getTotal() -> Double {
        var total : Double = 0
        for i in model.registrosGastos {
            total += i.importe!
        }
        
        return total
    }
    
    func getNombreMes() -> String {
        return model.fechaSeleccionada.nombreDelMes
    }
    
    
    
}


