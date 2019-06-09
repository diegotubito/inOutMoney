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
    
    func cargarRegistrosMesActual() {
        let fecha = model.fechaActual
        
        let mes = fecha.mes
        let año = fecha.año
        
        let path = UserID! + ProjectConstants.firebaseSubPath.registros
        let queryKeyName = ProjectConstants.queryKeyNames.query_MonthYear
        
        let nombreMes = MESES[mes]
        let añoStr = String(año)
        let periodo = nombreMes!+añoStr
        
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
            if i.type == ProjectConstants.rubros.gastoKey {
                result += i.importe ?? 0
            }
        }
        
        return result
    }
    
    func getTotalIngreso(registros: [IOProjectModel.Registro]) -> Double {
        var result : Double = 0
        for i in registros {
            if i.type == ProjectConstants.rubros.ingresoKey {
                result += i.importe ?? 0
            }
        }
        
        return result
    }
    
    func getTotal(childIDRubro: String, registros: [IOProjectModel.Registro]) -> Double {
        var result : Double = 0
        for i in registros {
            if i.childIDRubro == childIDRubro {
                result += i.importe ?? 0
            }
        }
        return result
    }
    
  
    
}
