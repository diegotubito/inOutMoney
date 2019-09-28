//
//  HomeViewModelProtocol.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {
    init(withView view: HomeViewProtocol, databaseService: MLFirebaseDatabase, authService: IOLoginFirebaseService)
    var model : HomeModel! {get}
    
    func cargarRubros()
    func cargarCuentas()
    func cargarRegistrosMesActual()
    func cargarRegistrosMesAnterior()
    func cargarRegistrosMesAnteriorAnterior()
    func cargarTodosLosRegistrosBeta(success: @escaping () -> Void, fail: @escaping ()->Void)
    func listenAuth()
    func signOut()
    
    func getTotalGasto(registros: [IOProjectModel.Registro]) -> Double
    func getTotalIngreso(registros: [IOProjectModel.Registro]) -> Double
    func getTotal(childIDRubro: String, registros: [IOProjectModel.Registro]) -> Double
    
    func convertDataForDDLineChart(cantidadDeMeses: Int, from: Date) -> DDLineChartModel
    func getRubrosGastos() -> [IOProjectModel.Rubro]?
    func getRubrosIngresos() -> [IOProjectModel.Rubro]?

 
}

protocol HomeViewProtocol {
    func reloadList()
    func disabledButtons()
    func enableButtons()
    func switchStoryboard()
    func showError(_ message: String)
    func showSuccess()
    func updateCuentas()
    func updateRegistrosMesActual(registros: [IOProjectModel.Registro])
    func updateRegistrosMesAnterior(registros: [IOProjectModel.Registro])
    func updateRegistrosMesAnteriorAnterior(registros: [IOProjectModel.Registro])
    func mostrarNombreMesActual()
    func mostrarNombreMesAnterior()
    func mostrarNombreMesAnteriorAnterior()

    func stopAnimatingActivityMesActual()
    func startAnimatingActivityMesActual()
    func stopAnimatingActivityMesAnterior()
    func startAnimatingActivityMesAnterior()
    func stopAnimatingActivityMesAnteriorAnterior()
    func startAnimatingActivityMesAnteriorAnterior()

}
