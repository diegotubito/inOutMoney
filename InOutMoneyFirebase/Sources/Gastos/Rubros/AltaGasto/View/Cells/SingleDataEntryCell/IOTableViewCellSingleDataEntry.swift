//
//  IOTableViewCellSingleDataEntry.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 24/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
protocol IOTableViewCellSingleDataEntryDelegate {
    func textDidChangeDelegate(tag: Int)
    func textDidEndEditingDelegate(tag: Int)
}

class IOTableViewCellSingleDataEntry: UITableViewCell {
    
    var delegate : IOTableViewCellSingleDataEntryDelegate?
    
    @IBOutlet var titleCell: UILabel!
    @IBOutlet var textFieldCell: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textFieldCell.delegate = self
        selectionStyle = .none
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

extension IOTableViewCellSingleDataEntry: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textDidEndEditingDelegate(tag: tag)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        delegate?.textDidChangeDelegate(tag: tag)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate?.textDidEndEditingDelegate(tag: tag)
        
    }
}
