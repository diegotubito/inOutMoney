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
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
        selectionStyle = .none
        addDoneButtonOnKeyboard()
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
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.textField.resignFirstResponder()
        
        /* Or:
         self.view.endEditing(true);
         */
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
