//
//  IOBorrarRubroGastoViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 6/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOBorrarRubroGastoViewModel: IOBorrarRubroGastoViewModelContract {
    var _view : IOBorrarRubroGastoViewContract!
    var model: IOBorrarRubroGastoModel!
    
    
    required init(withView view: IOBorrarRubroGastoViewContract, rubroSeleccionado: IORubroManager.Rubro) {
        _view = view
        model = IOBorrarRubroGastoModel(rubroRecibido: rubroSeleccionado)
    }
    
    
    func loadData() {
        //para borrar el rubro completo, primero debo cargar todos los registros pertenecientes al rubro.
        model.registros.removeAll()
        MLFirebaseDatabaseService.retrieveDataWithFilter(path: UserID! + "/gastos/registros", keyName: "childIDRubro", value: model.rubroRecibido.childID) { (response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }
            
            if response != nil {
                for i in response! {
                    let diccionario = i.value as! [String : Any]
                    let childIDRubro = diccionario[IORegistroManager.keyRegistro.childIDRubro] as! String
                    let childIDDebito = diccionario[IORegistroManager.keyRegistro.childIDDebito] as! String
                    let descripcion = diccionario[IORegistroManager.keyRegistro.descripcion] as! String
                    let fechaGasto = diccionario[IORegistroManager.keyRegistro.fechaGasto] as! String
                    let fechaGastoDate = fechaGasto.toDate(formato: formatoDeFecha.fecha)
                    let isEnabled = diccionario[IORegistroManager.keyRegistro.isEnabled] as! Bool
                    let fechaCrecion = diccionario[IORegistroManager.keyRegistro.fechaCreacion] as! String
                    let fechaCreacionDate = fechaCrecion.toDate(formato: formatoDeFecha.fechaConHora)
                    
                     let importe = diccionario[IORegistroManager.keyRegistro.importe] as! Double
                    
                    let nuevoRegistro = IORegistroManager.Registro(childID: i.key,
                                                                   childIDRubro: childIDRubro,
                                                                   childIDCuentaDebito: childIDDebito,
                                                                   descripcion: descripcion,
                                                                   fechaCreacion: fechaCreacionDate!,
                                                                   fechaGasto: fechaGastoDate!,
                                                                   importe: importe,
                                                                   isEnabled: isEnabled)
                    self.model.registros.append(nuevoRegistro)
                }
                self._view.reloadList()
            }
            
            
        }
    }
    
   
  
    func eliminarRubro() {
        let childID = model.rubroRecibido.childID
        
        for i in model.registros {

            let childIDDebito = i.childIDCuentaDebito
            let childIDRegistro = i.childID
            let importe = i.importe
            
            let pathCuenta = UserID! + "/cuentas/" + childIDDebito
            let pathRegistro = UserID! + "/gastos/registros/" + childIDRegistro
            
            MLFirebaseDatabaseService.setTransaction(path: pathCuenta, keyName: IOCuentaManager.keyCuenta.saldo, incremento: importe)
            MLFirebaseDatabaseService.delete(path: pathRegistro)
        }
        
        
        
        //borro el rubro
        MLFirebaseDatabaseService.delete(path: UserID! + "/gastos/rubros/" + childID) { (deleted, error) in
            if error != nil {
                self._view.showError(message: error?.localizedDescription ?? "Error desconocido")
                return
            }
            if deleted {
                self._view.showSuccess()
            }
        }
        
        
        
        
    }
 
 
}
