//
//  IODetalleRegistroGastoViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IODetalleRegistroGastoViewModel: IODetalleRegistroGastoViewModelContract {
   
    var model: IODetalleRegistroGastoModel!
    var _view : IODetalleRegistroGastoViewContract!
    
    required init(withView view: IODetalleRegistroGastoViewContract, registroSeleccionado: IORegistroManager.Registro) {
        _view = view
        model = IODetalleRegistroGastoModel(registroRecibido: registroSeleccionado)
        
    }
    
    func eliminar() {
        let path = UserID! + "/gastos/registros/" + model.registroRecibido.childID
        MLFirebaseDatabaseService.delete(path: path)
        MLFirebaseDatabaseService.delete(path: path) { (result, error) in
            if error != nil {
                self._view.showError(error?.localizedDescription ?? "Error al eliminar registro")
                return
            }
            
            self._view.showSuccess("Registro eliminado")
            
            let pathCuenta = UserID! + "/cuentas/" + self.model.registroRecibido.childIDCuentaDebito
            let importe = self.model.registroRecibido.importe
            MLFirebaseDatabaseService.setTransaction(path: pathCuenta, keyName: IOCuentaManager.keyCuenta.saldo, incremento: importe)
            
        }
    }
    
    func guardarCambios() {
        let childID = model.registroRecibido.childID
        let childIDRubro = model.registroRecibido.childIDRubro
        let keyFecha = _view.getFechaInput()
        let mes = keyFecha.mes
        let año = keyFecha.año
        let keyFechaString = MESES[mes]! + String(año)
        let queryRubroMesAño = childIDRubro + "#" + keyFechaString
        let queryRubroAño = childIDRubro + "#" + String(año)
        let queryMesAño = keyFechaString
        let queryAño = String(año)
        let childIDDebito = _view.getChildIDDebitoInput()
        let importe = _view.getImporteInput()
        
        let datos = ["queryRubroMesAño" : queryRubroMesAño,
                     "queryRubroAño" : queryRubroAño,
                     "queryMesAño" : queryMesAño,
                     "queryAño" : queryAño,
                     "childIDRubro" : childIDRubro,
                     "isEnabled" : 1,
                     "childIDDebito" : childIDDebito,
                     "descripcion" : _view.getDescripcion(),
                     "fechaGasto" : keyFecha.toString(formato: formatoDeFecha.fecha),
                     "importe" : importe] as [String : Any]
 
        let path = UserID! + "/gastos/registros/" + childID
        
        MLFirebaseDatabaseService.update(path: path, diccionario: datos, success: { (DatabaseReference) in
            self._view.showSuccess("Datos guardados.")
            
            //ajustamos la cuenta debitada
            let pathCuentaVieja = UserID! + "/cuentas/" + self.model.registroRecibido.childIDCuentaDebito
            let pathCuentaNueva = UserID! + "/cuentas/" + childIDDebito
            let importeViejo = self.model.registroRecibido.importe
            let importeNuevo = importe
            
            if self.model.registroRecibido.childIDCuentaDebito != childIDDebito {
                
                  MLFirebaseDatabaseService.setTransaction(path: pathCuentaVieja, keyName: IOCuentaManager.keyCuenta.saldo, incremento: importeViejo)

                    MLFirebaseDatabaseService.setTransaction(path: pathCuentaNueva, keyName: IOCuentaManager.keyCuenta.saldo, incremento: -importeNuevo)

            } else if importeViejo != importeNuevo {
                let diferencia = importeViejo - importeNuevo
                MLFirebaseDatabaseService.setTransaction(path: pathCuentaVieja, keyName: IOCuentaManager.keyCuenta.saldo, incremento: diferencia)
            }
        }) { (err) in
            self._view.showError(err?.localizedDescription ?? "Error al intentar guardar cambios")
        }
        
    }
    
    
}
