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
            //ahora que tengo los datos creo los items
            
            let infoGeneral = IORubrosProfileItem(type: IORubrosProfileType.headerInfo,
                                                  rowCount: 1,
                                                  titleSection: "Info General",
                                                  json: response!)
            self.model.items.append(infoGeneral)
            
            self._view.reloadList()
        }
    }
    
    
}
