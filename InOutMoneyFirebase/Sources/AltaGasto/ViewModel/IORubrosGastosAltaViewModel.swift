//
//  IORubrosGastosAltaViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 23/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IORubrosGastosAltaViewModel: IORubrosGastosAltaViewModelContract {

    var model: IOAltaGastoModel!
    var _view : IORubrosGastosAltaViewContract!
    
    required init(withView view: IORubrosGastosAltaViewContract, rubroSeleccionado: IORubroManager.Rubro) {
        model = IOAltaGastoModel(rubroRecibido: rubroSeleccionado)
        _view = view
    }
    
   func saveData() {
        let childIDRubro = model.rubroSeleccionado.childID
        let keyFecha = _view.getFechaTextField().toDate(formato: formatoDeFecha.fecha)
        let mes = keyFecha?.mes
        let año = keyFecha?.año
        let keyFechaString = MESES[mes!]! + String(año!)
        let queryByTypeMonthYear = childIDRubro + "#" + keyFechaString
        let queryByTypeYear = childIDRubro + "#" + String(año!)
        let queryByMonthYear = keyFechaString
        let queryByYear = String(año!)
        let childIDDebito = IOCuentaManager.cuentas[model.cuenta_selected_index!].childIDCuenta
        let importe = Double(_view.getMontoTextField())!
        
        let path = UserID! + ProjectConstants.firebaseSubPath.gastos
        
        
        let datos = [IOAltaGastoModel.KeyNames.queryByTypeMonthYear : queryByTypeMonthYear,
                     IOAltaGastoModel.KeyNames.queryByTypeYear : queryByTypeYear,
                     IOAltaGastoModel.KeyNames.queryByMonthYear : queryByMonthYear,
                     IOAltaGastoModel.KeyNames.queryByYear : queryByYear,
                     IOAltaGastoModel.KeyNames.childIDRubro : childIDRubro,
                     IOAltaGastoModel.KeyNames.isEnabled : 1,
                     IOAltaGastoModel.KeyNames.childIDDebito : childIDDebito,
                     IOAltaGastoModel.KeyNames.descripcion : _view.getDescripcionTextField(),
                     IOAltaGastoModel.KeyNames.fechaGasto : _view.getFechaTextField(),
                     IOAltaGastoModel.KeyNames.fechaCreacion : Date().toString(formato: formatoDeFecha.fechaConHora),
                     IOAltaGastoModel.KeyNames.importe : importe,
                     IOAltaGastoModel.KeyNames.type : ProjectConstants.rubros.gastoKey] as [String : Any]
        
        MLFirebaseDatabaseService.setDataWithAutoId(path: path, diccionario: datos, success: { (ref) in
            MLFirebaseDatabaseService.setTransaction(path: UserID! + ProjectConstants.firebaseSubPath.cuentas + "/" + childIDDebito, keyName: "saldo", incremento: -importe, success: {
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
        let array = IOCuentaManager.getDescriptionAndAmountArray()
        if array.count == 0 {
            _view.showError("No hay cuentas")
        }
    }
    
    
}
