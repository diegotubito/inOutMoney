//
//  IOTableViewCellSingleSwitchCell.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 24/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IOTableViewCellSingleSwitchCellDelegate {
    func switchDidChangedDelegate(_ sender: UISwitch)
}

class IOTableViewCellSingleSwitchCell: UITableViewCell {
    var delegate : IOTableViewCellSingleSwitchCellDelegate?

    @IBOutlet var titleCell: UILabel!
    @IBOutlet var switchOutletCell: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        sender.tag = tag
        delegate?.switchDidChangedDelegate(sender)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
