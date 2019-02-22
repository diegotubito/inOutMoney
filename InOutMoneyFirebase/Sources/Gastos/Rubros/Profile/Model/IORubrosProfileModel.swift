//
//  IORubrosProfileModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

enum IORubrosProfileType {
    case headerInfo
    case botonAgregarRegistro
    case registros
}

class IORubrosProfileModel {
    var rubroRecibido : IORubrosListadoModel.rowData
    var items = [IORubrosProfileItem]()
    
    init(rubro: IORubrosListadoModel.rowData) {
        self.rubroRecibido = rubro
        
    }
}


class IORubrosProfileItem {
    var type : IORubrosProfileType
    var rowCount : Int
    var titleSection : String
    var json : [String : Any]

    init(type: IORubrosProfileType, rowCount: Int, titleSection: String, json: [String: Any]) {
        self.type = type
        self.rowCount = rowCount
        self.titleSection = titleSection
        self.json = json
    }

}
