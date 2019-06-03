//
//  IOTableViewCellSingleTextField.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IOTableViewCellSingelTextFieldDelegate {
    func textFieldDidChangedDelegate(textField: UITextField)
    func textFieldDidFinishedDelegate(textField: UITextField)
}

class IOTableViewCellSingleTextField: UITableViewCell {
    var delegate : IOTableViewCellSingelTextFieldDelegate?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        textField.delegate = self
        
        // Configure the view for the selected state
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}

extension IOTableViewCellSingleTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.delegate?.textFieldDidChangedDelegate(textField: textField)
        return true
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.textFieldDidChangedDelegate(textField: textField)
        self.delegate?.textFieldDidFinishedDelegate(textField: textField)

        return true
    }
    
}
