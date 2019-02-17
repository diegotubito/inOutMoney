//
//  MBProductoProfileModel.swift
//  contractExample
//
//  Created by David Diego Gomez on 23/12/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit

class MBRubrosHeaderProfileModel {
    
    var type : MBRubrosListadoViewModelItemType
    var rowCount : Int
    var leftLabel : String
    var rightLabel : String
    var buttonTitle : String
    
    init(type: MBRubrosListadoViewModelItemType, leftLabel: String, rightLabel: String, buttonTitle: String, rowCount: Int) {
        self.type = type
        self.rowCount = rowCount
        self.leftLabel = leftLabel
        self.rightLabel = rightLabel
        self.buttonTitle = buttonTitle
 
    }
}

class MBRubrosListadoProfileModel {
  
    var type : MBRubrosListadoViewModelItemType
    var rowCount : Int
    var titleSection : String
    var desplegable : Bool
    var json : [String : Any]
    var image : UIImage?
    
    init(type: MBRubrosListadoViewModelItemType, titleSection: String, desplegable: Bool, rowCount: Int, json: [String:Any]) {
        self.desplegable = desplegable
        self.type = type
        self.rowCount = rowCount
        self.json = json
        self.titleSection = titleSection
        self.image = nil
    }
}
