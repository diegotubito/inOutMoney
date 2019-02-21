//
//  IORubrosProfileModel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation


class IORubrosProfileModel {
    var rubroRecibido : IORubrosListadoModel.rowData
    
    init(rubro: IORubrosListadoModel.rowData) {
        self.rubroRecibido = rubro
    }
}
