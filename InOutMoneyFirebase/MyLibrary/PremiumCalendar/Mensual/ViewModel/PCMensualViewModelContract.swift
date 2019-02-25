//
//  PCMensualViewModelContract.swift
//  PremiumCalendar
//
//  Created by David Diego Gomez on 6/1/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol PCMensualViewModelContract {
    init(withCustomView view: PCMensualViewContract)
    func selectedView(_ view: PCDiaCustomView)
    func finishedWithSelection()
    var model : PCMensualModel {get set}
    func getNameDay(index: Int) -> String
    func getMonth() -> Int
    func getMonthName() -> String
    func getYear() -> Int
    
    
    func avanzarMes()
    func retrocederMes()
 }

protocol PCMensualViewContract {
    func updateView()
    func deselectAll()
    func updateDays()
    func getDayAttibutes(fecha: Date, fila: Int, columna: Int) -> PCMensualDayAttribute
    func pintarSelectedDate(view: PCDiaCustomView)
    func showSelectedItems()
    func highlightBorderForFinishedSelection()
    func dimmBorderForUnfinishedSelection()
    
    func hideMesIzquierda(completion: @escaping () -> Void)
    func showMesDerecha(completion: @escaping () -> Void)
    func hideMesDerecha(completion: @escaping () -> Void)
    func showMesIzquierda(completion: @escaping () -> Void)
    func setMonthTitle()
    
    func hideYear(completion: @escaping () -> Void)
    func showYear(completion: @escaping () -> Void)
    func setYearTitle()
    
    
    func hideCuerpoIzquierda(completion: @escaping () -> Void)
    func showCuerpoDerecha(completion: @escaping () -> Void)
    func hideCuerpoDerecha(completion: @escaping () -> Void)
    func showCuerpoIzquierda(completion: @escaping () -> Void)

}


