//
//  IOTableViewCellHeaderInfo.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 22/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOTableViewCellHeaderInfo: UITableViewCell {

    @IBOutlet var mes: UILabel!
    @IBOutlet var total: UILabel!
    
    var item: IORubrosProfileItem? {
        didSet {
            guard let item = item as? ProfileViewModelRubrosHeaderItem else {
                return
            }
            
            mes?.text = item.mes
            total?.text = item.total.formatoMoneda(decimales: 2, simbolo: "$")
            
        }
    }
    
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
