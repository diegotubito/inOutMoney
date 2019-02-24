//
//  IOTableViewCellBotonAgregarRegistro.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 23/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IOTableViewCellBotonAgregarRegistroDelegate {
    
    func addButtonPressedDelegate()
    
}
class IOTableViewCellBotonAgregarRegistro: UITableViewCell {
    
    var delegate : IOTableViewCellBotonAgregarRegistroDelegate?

    @IBOutlet var button: UIButton!
    
    var item: IORegistroGastos? {
        didSet {
            guard let item = item else {
                return
            }
         
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
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.delegate?.addButtonPressedDelegate()
    }
}
