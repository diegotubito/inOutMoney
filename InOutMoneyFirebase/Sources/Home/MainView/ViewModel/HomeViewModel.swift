//
//  HomeViewModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import Firebase

class HomeViewModel : HomeViewModelProtocol {
    
    var model: HomeModel!
    var _view : HomeViewProtocol!
    var _databaseService : MLFirebaseDatabase!
    var _authService : IOLoginFirebaseService!
    var authListener : AuthStateDidChangeListenerHandle!
    
    
    required init(withView view: HomeViewProtocol, databaseService: MLFirebaseDatabase, authService: IOLoginFirebaseService) {
        _view = view
        _databaseService = databaseService
        _authService = authService
        model = HomeModel()
    }
    
   
    func listenAuth() {
        
        authListener = Auth.auth().addStateDidChangeListener() { auth, user in
            
            UserID = user?.uid
            
            
            if user == nil {
                print("no hay usuario autenticado")
                Auth.auth().removeStateDidChangeListener(self.authListener)
                self._view.switchStoryboard()
                
            } else {
                print("you are logged in \(String(describing: user?.uid))")
                self._view.reloadList()
            }
        }
    }
    
    func signOut() {
        _authService.signOut(success: {
            print("sign out")
        }) {
            print("error al intentar sign out")
        }
    }
    
    func cargarRubros() {
        model.rubros?.removeAll()
        
        let path = UserID! + ProjectConstants.firebaseSubPath.rubros
        _view.disabledButtons()
        _databaseService.fetch(path: path, completion: { (rubros: [IOProjectModel.Rubro]?) in
            if rubros != nil {
                self.model.rubros = rubros!
            }
            self._view.enableButtons()
        }) { (error) in
            print(error?.localizedDescription ?? ProjectConstants.unknownError)
            self._view.enableButtons()
        }
        
    }
    
    
    func cargarCuentas() {
        _databaseService.fetch(path: UserID! + ProjectConstants.firebaseSubPath.cuentas, completion: { (cuentas: [IOProjectModel.Cuenta]?) in
            if cuentas != nil {
                self.model.cuentas = cuentas!
            }
            self._view.updateCuentas()
        }) { (error) in
            self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
    }
    
    func cargarTodosLosRegistrosBeta(success: @escaping () -> Void, fail: @escaping () -> Void) {
        let path = UserID! + ProjectConstants.firebaseSubPath.registros
        
        MLFirebaseDatabase.instance.fetch(path: path, completion: { (registros: [IOProjectModel.Registro]?) in
            if registros != nil {
                self.model.todosLosRegistros = registros!
            }
            success()
        }) { (error) in
            fail()
        }
    }
    
    func cargarRegistrosMesActual() {
        let fecha = model.fechaActual
        
        let mes = fecha.mes
        let año = fecha.año
        
        let path = UserID! + ProjectConstants.firebaseSubPath.registros
        let queryKeyName = ProjectConstants.queryKeyNames.query_MonthYear
        
        let nombreMes = MESES[mes]
        let añoStr = String(año)
        let periodo = nombreMes!+añoStr
        
        model.nombreMesActual = nombreMes
        _view.mostrarNombreMesActual()
        
        self.model.registrosMesActual?.removeAll()
        _view.startAnimatingActivityMesActual()
        MLFirebaseDatabase.instance.fetchWithQuery(path: path, keyName: queryKeyName, value: periodo, completion: { (registros : [IOProjectModel.Registro]?) in
            self._view.stopAnimatingActivityMesActual()
            if registros != nil {
                self.model.registrosMesActual = registros!
                self._view.updateRegistrosMesActual(registros: registros!)
            }
        }) { (error) in
            self._view.stopAnimatingActivityMesActual()
            self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
    }
    
    func cargarRegistrosMesAnterior() {
        let fecha = Calendar.current.date(byAdding: .month, value: -1, to: model.fechaActual)
        
        let mes = fecha!.mes
        let año = fecha!.año
        
        let path = UserID! + ProjectConstants.firebaseSubPath.registros
        let queryKeyName = ProjectConstants.queryKeyNames.query_MonthYear
        
        let nombreMes = MESES[mes]
        let añoStr = String(año)
        let periodo = nombreMes!+añoStr
        
        model.nombreMesAnterior = nombreMes!
        _view.mostrarNombreMesAnterior()
        
        self.model.registrosMesAnterior?.removeAll()
        _view.startAnimatingActivityMesAnterior()
        MLFirebaseDatabase.instance.fetchWithQuery(path: path, keyName: queryKeyName, value: periodo, completion: { (registros : [IOProjectModel.Registro]?) in
            self._view.stopAnimatingActivityMesAnterior()
            if registros != nil {
                self.model.registrosMesAnterior = registros!
                self._view.updateRegistrosMesAnterior(registros: registros!)
            }
        }) { (error) in
            self._view.stopAnimatingActivityMesAnterior()
            self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
    }
    
    func cargarRegistrosMesAnteriorAnterior() {
        let fecha = Calendar.current.date(byAdding: .month, value: -2, to: model.fechaActual)
        
        let mes = fecha!.mes
        let año = fecha!.año
        
        let path = UserID! + ProjectConstants.firebaseSubPath.registros
        let queryKeyName = ProjectConstants.queryKeyNames.query_MonthYear
        
        let nombreMes = MESES[mes]
        let añoStr = String(año)
        let periodo = nombreMes!+añoStr
        
        model.nombreMesAnteriorAnterior = nombreMes
        _view.mostrarNombreMesAnteriorAnterior()
        
        self.model.registrosMesAnteriorAnterior?.removeAll()
        _view.startAnimatingActivityMesAnteriorAnterior()
        MLFirebaseDatabase.instance.fetchWithQuery(path: path, keyName: queryKeyName, value: periodo, completion: { (registros : [IOProjectModel.Registro]?) in
            self._view.stopAnimatingActivityMesAnteriorAnterior()
            if registros != nil {
                self.model.registrosMesAnteriorAnterior = registros!
                self._view.updateRegistrosMesAnteriorAnterior(registros: registros!)
            }
        }) { (error) in
            self._view.stopAnimatingActivityMesAnteriorAnterior()
            self._view.showError(error?.localizedDescription ?? ProjectConstants.unknownError)
        }
    }
    
    func getTotalGasto(registros: [IOProjectModel.Registro]) -> Double {
        var result : Double = 0
        for i in registros {
            let isEnabled = Bool(truncating: i.isEnabled! as NSNumber)
            if i.type == ProjectConstants.rubros.gastoKey && isEnabled{
                result += i.importe ?? 0
            }
        }
        
        return result
    }
    
    func getTotalIngreso(registros: [IOProjectModel.Registro]) -> Double {
        var result : Double = 0
        for i in registros {
            let isEnabled = Bool(truncating: i.isEnabled! as NSNumber)
            if i.type == ProjectConstants.rubros.ingresoKey && isEnabled {
                result += i.importe ?? 0
            }
        }
        
        return result
    }
    
    func getTotal(childIDRubro: String, registros: [IOProjectModel.Registro]) -> Double {
        var result : Double = 0
        for i in registros {
            let isEnabled = Bool(truncating: i.isEnabled! as NSNumber)
            
            if i.childIDRubro == childIDRubro && isEnabled {
                result += i.importe ?? 0
            }
        }
        return result
    }
    
    private func getTotalGasto(startDate: Date, endDate: Date) -> Double {
        var result : Double = 0
        
        for i in model.todosLosRegistros! {
            let fecha = i.fechaGasto?.toDate(formato: formatoDeFecha.fechaConHora)
            if fecha! > startDate && fecha! < endDate {
                result += i.importe!
            }
        }
        
        return result
    }
 
    func convertDataForDDLineChart(cantidadDeMeses: Int, from: Date) -> DDLineChartModel {
        let result = DDLineChartModel()
      
        var fechaAux = from
        var mesAux = 0
        var añoAux = 0
        
        let fromAux = Calendar.current.date(byAdding: .month, value: -cantidadDeMeses + 1, to: from)!
        
        for itereacion in 0...(cantidadDeMeses-1) {
            fechaAux = Calendar.current.date(byAdding: .month, value: itereacion, to: fromAux)!
            mesAux = fechaAux.mes
            añoAux = fechaAux.año
            let query = MESES[mesAux]! + String(añoAux)
            
            var suma : Double = 0
            if let array = model.todosLosRegistros?.filter({ $0.queryByMonthYear == query }) {
                for i in array {
                    if i.isEnabled == 1 && i.type == ProjectConstants.rubros.gastoKey{
                        suma += i.importe!
                    }
                }
            }
            
            
            result.values.append(suma)
            result.labels.append(String(MESES[mesAux]!.prefix(3)))
        }
        
    
        return result
    }
    
    func getRubrosGastos() -> [IOProjectModel.Rubro]? {
        return model.rubros?.filter({$0.type == ProjectConstants.rubros.gastoKey})
    }
    
    func getRubrosIngresos() -> [IOProjectModel.Rubro]? {
        return model.rubros?.filter({$0.type == ProjectConstants.rubros.ingresoKey})
    }
}
