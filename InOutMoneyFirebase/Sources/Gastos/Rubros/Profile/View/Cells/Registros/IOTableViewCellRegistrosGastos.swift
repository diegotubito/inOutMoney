//
//  IOTableViewCellRegistrosGastos.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 23/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOTableViewCellRegistrosGastos: UITableViewCell {
    
    @IBOutlet weak var descripcionCell: UILabel?
    @IBOutlet weak var fechaCell: UILabel?
    @IBOutlet var importeCell: UILabel!
    
    var item: IORegistroGastos? {
        didSet {
            guard let item = item else {
                return
            }
            fechaCell?.text = item.fecha
            descripcionCell?.text = item.descripcion
            importeCell.text = "$ " + String(item.importe ?? 0.0)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
