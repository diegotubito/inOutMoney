//
//  IOMovimientoViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation


class IOMovimientoViewModel: IOMovimientoViewModelContract {
    
    
    var _view : IOMovimientoViewContract!
    var model : IOMovimientoModel!
    var _service : MLFirebaseDatabase!
    
    required init(withView view: IOMovimientoViewContract, service: MLFirebaseDatabase) {
        self._view = view
        self.model = IOMovimientoModel()
        self._service = service
    }
    
    func cargarRegistros() {
        model.registros.removeAll()
        
        let path = UserID! + ProjectConstants.firebaseSubPath.registros
        _view.showLoading()
        _service.fetch(path: path, completion: { (registros: [IOProjectModel.Registro]?) in
            self._view.hideLoading()
            if registros != nil {
                let sortedArray = registros!.sorted(by: { $0.fechaCreacion! > $1.fechaCreacion! })
                
                self.transformToSections(registros: sortedArray)
            }
            self._view.showSuccess()
        }) { (error) in
            self._view.hideLoading()
            self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
    }
    
    private func transformToSections(registros: [IOProjectModel.Registro]) {
        model.registros.removeAll()
        
        for i in registros {
            if let fecha = i.fechaCreacion?.prefix(10) {
                if !existeFecha(fecha: String(fecha)) {
                    let array = registros.filter({$0.fechaCreacion?.prefix(10) == fecha})
                    model.registros.append(array)
                }
            }
            
        }
    }
    
    private func existeFecha(fecha: String) -> Bool {
        for i in model.registros {
            for a in i {
                if let fechaComparable = a.fechaCreacion {
                    if fechaComparable.prefix(10) == fecha {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    func anularReestablecer(section: Int, row: Int, value: Int) {
        let registro = model.registros[section][row]
        var signo = 1
        if value == 0 {
            signo = -1
        }
        let tipo = registro.type
        if tipo == ProjectConstants.rubros.gastoKey {
            signo = signo * (-1)
        }
        if let key = registro.key {
        
  
            let path = UserID! + ProjectConstants.firebaseSubPath.registros + "/" + key
            let diccionario = ["isEnabled" : value,
                               "fechaModificacion" : Date().toString(formato: formatoDeFecha.fechaConHora)] as [String : Any]
            
            MLFirebaseDatabase.update(path: path, diccionario: diccionario, success: { (response) in
                
                NotificationCenter.default.post(name: .updateRegistros, object: nil)
                
                //update account
                let importe = registro.importe!
                let childIDDebito = registro.childIDDebito!
                
                MLFirebaseDatabase.setTransaction(path: UserID! + ProjectConstants.firebaseSubPath.cuentas + "/" + childIDDebito, keyName: "saldo", incremento: Double(signo) * importe, success: {
                    NotificationCenter.default.post(name: .updateCuentas, object: nil)
                }, fail: { (error) in
                    self._view.showError(error as! String)
                })
                
                
            }) { (error) in
                self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
            }
        } else {
            _view.showError("No se pudo localizar registro.")
        }
    }
    
    func eliminarRegistro(section: Int, row: Int) {
        let registro = model.registros[section][row]
        
        if let key = registro.key {
            let path = UserID! + ProjectConstants.firebaseSubPath.registros + "/" + key
            MLFirebaseDatabase.delete(path: path) { (finished, error) in
                if error != nil  {
                    self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
                    return
                }
                
                self.cargarRegistros()
                
            }
        }
    }
    
}
