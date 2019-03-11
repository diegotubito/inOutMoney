//
//  IOTableViewCellBotonGuardar.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 24/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
protocol IOTableViewCellBotonGuardarDelegate {
    func buttonPressedDelegate(_ sender: UIButton)
}

class IOTableViewCellBotonGuardar: UITableViewCell {

    var delegate : IOTableViewCellBotonGuardarDelegate?
    
    @IBOutlet var buttonCellOutlet: UIButton!
    @IBOutlet var titleCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        disableButton()
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
    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.tag = tag
        delegate?.buttonPressedDelegate(sender)
    }
    
    func enableButton() {
        buttonCellOutlet.isEnabled = true
        titleCell.textColor = UIColor.blue
    }
    
    func disableButton() {
        buttonCellOutlet.isEnabled = false
        titleCell.textColor = UIColor.lightGray
    }
}
