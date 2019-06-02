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
    
    required init(withView view: IOAltaIngresoViewContract, rubroSeleccionado: IORubroManager.Rubro) {
        self._view = view
        self.model = IOAltaIngresoModel(rubroRecibido: rubroSeleccionado)
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
        
        let path = UserID! + ProjectConstants.firebaseSubPath.ingresos
        
        
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
                     IOAltaGastoModel.KeyNames.type : ProjectConstants.rubros.ingresoKey] as [String : Any]
        
        MLFirebaseDatabaseService.setDataWithAutoId(path: path, diccionario: datos, success: { (ref) in
            MLFirebaseDatabaseService.setTransaction(path: UserID! + ProjectConstants.firebaseSubPath.cuentas + "/" + childIDDebito, keyName: "saldo", incremento: importe, success: {
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
