//
//  IORubrosListadoViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IORubrosListadoViewModel: IORubrosListadoViewModelContract {
   
    var _view : IORubrosListadoViewContract!
    var model : IORubrosListadoModel!
    
    required init(withView view: IORubrosListadoViewContract) {
        _view = view
        model = IORubrosListadoModel()
    }
    
    func loadData() {
        MLFirebaseDatabaseService.retrieveData(path: UserID! + "/gastos") { (response, error) in
            if error == nil {
                print(error?.localizedDescription ?? "error unknown")
                return
            }
            
            if response == nil {
                print("no hay datos")
                return
            }
            
            for i in response! {
                if let registro = i.value as? [String : Any] {
                    let descripcion = registro["descripcion"] as! String
                    let fechaCreacionStr = registro["fechaCreacion"] as! String
                    let fechaCreacion = fechaCreacionStr.toDate(formato: formatoDeFecha.fechaConHora)
                    let newRegister = IORubrosListadoModel.rowData(descripcion: descripcion,
                                                                   fechaCreacion: fechaCreacion!)
                    
                    self.model.listado?.append(newRegister)
                }
            }
            
            self._view.reloadList()
            
        }
    }
    
}
