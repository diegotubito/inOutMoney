//
//  funcionesGlobales.swift
//  coreGym
//
//  Created by David Diego Gomez on 11/7/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//


import UIKit


func queDiaEmpiezaElMes(fecha: Date) -> Int {
    
    let fechaSeleccionada = "01-" + String(mesDeLaFecha(fecha: fecha)) + "-" + String(añoDeLaFecha(fecha: fecha))
    let formatter  = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    
    var diaInicial = Int()
    if let todayDate = formatter.date(from: fechaSeleccionada) {
        let myCalendar = Calendar(identifier: .gregorian)
        diaInicial = myCalendar.component(.weekday, from: todayDate)
    }
    
    
    return diaInicial
}


func cuantosDiasTieneElMes(fecha: Date) -> Int{
    let myCalendar = Calendar(identifier: .gregorian)
    
    // Calculate start and end of the current year (or month with `.month`):
    let interval = myCalendar.dateInterval(of: .month, for: fecha)!
    
    // Compute difference in days:
    let days = myCalendar.dateComponents([.day], from: interval.start, to: interval.end).day!
    return days
}



func diaDelAño(fecha: Date) -> Int? {
    
     let numeroDeDia = Calendar.current.ordinality(of: .day, in: .year, for: fecha)
    
    return numeroDeDia
}

func diaDeLaFecha(fecha: Date) -> Int {
    
    let calendar = Calendar.current
    let numeroDeDia = calendar.component(.day, from: fecha)
    
    return numeroDeDia
}

func diaDeLaSemana(fecha: Date) -> String {
    let calendar = Calendar.current
    let diaDeLaSemana = calendar.component(.weekday, from: fecha)
    
    return DIAS[diaDeLaSemana]!
}

func añoDeLaFecha(fecha: Date) -> Int {
    let calendar = Calendar.current
    let año = calendar.component(.year, from: fecha)
    
    return año
}

func mesDeLaFecha(fecha: Date) -> Int {
    let calendar = Calendar.current
    let mes = calendar.component(.month, from: fecha)
    
    return mes
}

func numeroDecimalConSignoMoneda(numero: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = NSLocale.current
    numberFormatter.currencySymbol = "$"
    numberFormatter.numberStyle = NumberFormatter.Style.currencyAccounting
    let formatoFinal = numberFormatter.string(from: NSNumber(value:numero))!
    
    return String(formatoFinal)
    
}


