//
//  IOMoverRegistroGastoViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 7/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOMoverRegistroGastoViewModel: IOMoverRegistroGastoViewModelContract {
    var _view : IOMoverRegistroGastoViewContract!
    var model: IOMoverRegistroGastoModel!
    
    
    required init(withView view: IOMoverRegistroGastoViewContract, rubroSeleccionado: IORubroManager.Rubro) {
        _view = view
        model = IOMoverRegistroGastoModel(rubroRecibido: rubroSeleccionado)
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
    
    
    
    func moverRegistros() {
       
        
        
         let childIDNuevo = model.rubrosDisponibles[model.rubroElegido!].childID
        
        for i in model.registros {
            let dato = [IORegistroManager.keyRegistro.childIDRubro : childIDNuevo]
            let path = UserID! + "/gastos/registros/" + i.childID
            MLFirebaseDatabaseService.update(path: path, diccionario: dato)
           
        }
        
    }
    
    
    func setRubroSeleccionado(_ valor: Int) {
        model.rubroElegido = valor
    }
    
    func filtrarRubrosDisponibles() {
        model.rubrosDisponibles.removeAll()
        for i in IORubroManager.rubros {
            if i.isEnabled && i.childID != model.rubroRecibido.childID {
                model.rubrosDisponibles.append(i)
            }
        }
    }
    
    func seleccionarRubroPorDefecto() {
        if model.rubrosDisponibles.count > 0 {
            setRubroSeleccionado(0)
        }
    }
    
}

