//
//  IOTableViewCellSingleLabel.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOTableViewCellSingleLabel: UITableViewCell {

    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        leftImage.layer.cornerRadius = leftImage.frame.width/2

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
