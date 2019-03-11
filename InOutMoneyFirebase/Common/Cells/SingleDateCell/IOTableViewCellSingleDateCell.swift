//
//  IOTableViewCellSingleDateCell.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 24/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IOTableViewCellSingleDateCellDelegate {
    func buttonCellPressedDelegate(_ sender: UIButton)
}

class IOTableViewCellSingleDateCell: UITableViewCell {
    var delegate : IOTableViewCellSingleDateCellDelegate?

    @IBOutlet var titleCell: UILabel!
    @IBOutlet var valueCell: UILabel!
    @IBOutlet var outletButtonCell: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.tag = tag
        delegate?.buttonCellPressedDelegate(sender)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
