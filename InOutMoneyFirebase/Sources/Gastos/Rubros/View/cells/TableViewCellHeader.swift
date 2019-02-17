//
//  TableViewCellHeader.swift
//  contractExample
//
//  Created by David Diego Gomez on 24/12/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit

class TableViewCellHeader: UITableViewCell {

    @IBOutlet var titulo: UILabel!
    @IBOutlet var labelDesplegar: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}