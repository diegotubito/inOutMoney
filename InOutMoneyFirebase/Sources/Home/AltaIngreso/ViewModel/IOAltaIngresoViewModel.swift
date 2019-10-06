//
//  IOAltaIngresoViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 1/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation


class IOAltaIngresoViewModel: IOAltaIngresoViewModelContract {
   
    var _view : IOAltaIngresoViewContract!
    var model : IOAltaIngresoModel!
    
    required init(withView view: IOAltaIngresoViewContract, rubroSeleccionado: IOProjectModel.Rubro, cuentas: [IOProjectModel.Cuenta]) {
        self._view = view
        self.model = IOAltaIngresoModel(rubroRecibido: rubroSeleccionado, cuentas: cuentas)
    }
    
    func saveData() {
        let childIDRubro = model.rubroSeleccionado.key
        let keyFecha = _view.getFechaTextField().toDate(formato: formatoDeFecha.fecha)
        let mes = keyFecha?.mes
        let año = keyFecha?.año
        let keyFechaString = MESES[mes!]! + String(año!)
        let queryByTypeMonthYear = childIDRubro + "#" + keyFechaString
        let queryByTypeYear = childIDRubro + "#" + String(año!)
        let queryByMonthYear = keyFechaString
        let queryByYear = String(año!)
        let childIDDebito = model.cuentas[model.cuenta_selected_index!].key
        let importe = Double(_view.getMontoTextField())!
        
        let path = UserID! + ProjectConstants.firebaseSubPath.registros
        
        
        let datos = [ProjectConstants.KeyNames.Registro.queryByTypeMonthYear : queryByTypeMonthYear,
                     ProjectConstants.KeyNames.Registro.queryByTypeYear : queryByTypeYear,
                     ProjectConstants.KeyNames.Registro.queryByMonthYear : queryByMonthYear,
                     ProjectConstants.KeyNames.Registro.queryByYear : queryByYear,
                     ProjectConstants.KeyNames.Registro.childIDRubro : childIDRubro,
                     ProjectConstants.KeyNames.Registro.isEnabled : 1,
                     ProjectConstants.KeyNames.Registro.childIDDebito : childIDDebito,
                     ProjectConstants.KeyNames.Registro.descripcion : _view.getDescripcionTextField(),
                     ProjectConstants.KeyNames.Registro.fechaGasto : _view.getFechaTextField(),
                     ProjectConstants.KeyNames.Registro.fechaCreacion : Date().toString(formato: formatoDeFecha.fechaConHora),
                     ProjectConstants.KeyNames.Registro.fechaCreacionDouble : Date().timeIntervalSince1970,
                     ProjectConstants.KeyNames.Registro.importe : importe,
                     ProjectConstants.KeyNames.Registro.type : ProjectConstants.rubros.ingresoKey] as [String : Any]
        
        MLFirebaseDatabase.setDataWithAutoId(path: path, diccionario: datos, success: { (ref) in
            
            NotificationCenter.default.post(name: .updateRegistros, object: nil)
            
            MLFirebaseDatabase.setTransaction(path: UserID! + ProjectConstants.firebaseSubPath.cuentas + "/" + childIDDebito, keyName: "saldo", incremento: importe, success: {
                
                NotificationCenter.default.post(name: .updateCuentas, object: nil)
                
                self._view.showSuccess()
            }, fail: { (error) in
                self._view.showError(error as! String)
            })
            
        }) { (error) in
            self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
        
    }
    
    func set_cuenta_selected_index(_ value: Int?) {
        model.cuenta_selected_index = value
    }
    
    func check_accounts() {
        let array = getDescriptionAndAmountArray()
        if array.count == 0 {
            _view.showError("No hay cuentas")
        }
    }
    
    
    func getDescriptionArray() -> [String] {
        let array = model.cuentas.compactMap({ $0.descripcion })
        
        return array
    }
    
    func getAmountArray() -> [Double] {
        let array = model.cuentas.compactMap({ Double($0.saldo) })
        
        return array
    }
    
    func getCodeArray() -> [String] {
        let array = model.cuentas.compactMap({ $0.key })
        
        return array
    }
    
    func getDescriptionAndAmountArray() -> [String] {
        var array = [String]()
        for i in model.cuentas {
            array.append(i.descripcion + " " + i.saldo.formatoMoneda(decimales: 2, simbolo: "$"))
        }
        return array
    }
    
}
