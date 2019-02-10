//
//  configEncriptar.swift
//  coreGym
//
//  Created by David Diego Gomez on 13/7/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//


import UIKit

class _configEncrypt {
    public static let shared = _configEncrypt()
    
    func checkSum(cadena: String) -> UInt32 {
        var valor : UInt32 = 0
        for i in cadena.unicodeScalars {
            valor += i.value
        }
        return valor
    }
    
    func encriptar(cadena: String, clave: UInt32) -> String {
        var newValue = ""
        
        for i in cadena.unicodeScalars {
            
            newValue += String(Character(UnicodeScalar(i.value + clave)!))
        }
        
        return newValue
    }
    
    func desencriptar(cadena: String, clave: UInt32) -> String {
        var newValue = ""
        for i in cadena.unicodeScalars {
            newValue += String(Character(UnicodeScalar(i.value - clave)!))
            
        }
        
        return newValue
    }
    
    
}

