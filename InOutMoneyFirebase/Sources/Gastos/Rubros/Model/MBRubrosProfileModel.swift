//
//  MBProductoProfileModel.swift
//  contractExample
//
//  Created by David Diego Gomez on 23/12/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

class Profile {
    var rubros = [Rubro]()
    
    init?(data: [String : Any]) {
        if let rubros = data["friends"] as? [[String: Any]] {
            self.rubros = rubros.map { Rubro(json: $0) }
        }
    }
    
}

class Rubro {
    var isOpen : Bool
    var leftLabel: String?
    var rightLabel: String?
    var buttonLabel: String?
    
    init(json: [String: Any]) {
        self.leftLabel = json["descripcion"] as? String
        self.rightLabel = "122.22"
        self.isOpen = false
        self.buttonLabel = "↓"
    }
}
