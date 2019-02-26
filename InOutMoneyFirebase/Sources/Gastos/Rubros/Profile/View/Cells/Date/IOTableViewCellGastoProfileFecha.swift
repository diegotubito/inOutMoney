//
//  IOTableViewCellGastoProfileFecha.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 26/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOTableViewCellGastoProfileFecha: UITableViewCell {

    @IBOutlet var titleCell: UILabel!
    
    var item: IORubrosProfileItem? {
        didSet {
            guard let item = item as? ProfileViewModelFechaGastosItem else {
                return
            }
            let dia = item.fecha?.dia
            let nombreDia = item.fecha?.nombreDelDia
            titleCell?.text = nombreDia! + " " + String(dia!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
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
