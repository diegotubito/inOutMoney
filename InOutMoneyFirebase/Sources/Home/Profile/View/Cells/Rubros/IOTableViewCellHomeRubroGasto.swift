//
//  IOTableViewCellHomeRubroGasto.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOTableViewCellHomeRubroGasto: UITableViewCell {

    @IBOutlet weak var descripcionCell: UILabel?
    @IBOutlet weak var totalCell: UILabel?
    
    var item: IORubroManager.Rubro? {
        didSet {
            guard let item = item else {
                return
            }
            
            
            descripcionCell?.text = item.descripcion
            totalCell?.text = IORegistroManager.getTotal(childIDRubro: item.childID).formatoMoneda(decimales: 2, simbolo: "$")
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        selectionStyle = .none
    }
    
}
