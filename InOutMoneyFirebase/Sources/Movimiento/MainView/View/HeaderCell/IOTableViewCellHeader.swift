//
//  IOTableViewCellHeader.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 11/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOTableViewCellHeader: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    var myTag : Int = 0
    
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
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}