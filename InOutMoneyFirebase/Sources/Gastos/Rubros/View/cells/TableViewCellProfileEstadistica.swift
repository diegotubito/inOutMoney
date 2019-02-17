//
//  TableViewCellProfileEstadistica.swift
//  contractExample
//
//  Created by David Diego Gomez on 23/12/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit

class TableViewCellProfileEstadistica: UITableViewCell {

    @IBOutlet var cantidadVendida: UILabel!
    @IBOutlet var fondo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fondo.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
}
