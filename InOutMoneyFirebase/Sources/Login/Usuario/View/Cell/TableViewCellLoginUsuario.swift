//
//  TableViewCellLoginContraseña.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 2/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class TableViewCellLoginUsuario: UITableViewCell {
    
    @IBOutlet var content: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     /*
        content.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: content, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.height/2)
        let c2 = NSLayoutConstraint(item: content, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let c3 = NSLayoutConstraint(item: content, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let c4 = NSLayoutConstraint(item: content, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        contentView.addConstraints([c1, c2, c3,c4])
 */
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
