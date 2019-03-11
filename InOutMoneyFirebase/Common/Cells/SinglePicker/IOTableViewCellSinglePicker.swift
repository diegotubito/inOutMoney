//
//  IOTableViewCellSinglePicker.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 24/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
protocol IOTableViewCellSinglePickerDelegate {
    func pickerDidSelected(row: Int)
}
class IOTableViewCellSinglePicker: UITableViewCell {

    var delegate : IOTableViewCellSinglePickerDelegate?
    
    var arrayComponets : [String] = [String]()
    @IBOutlet var titleCell: UILabel!
    @IBOutlet var picker: UIPickerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        picker.dataSource = self
        picker.delegate = self
    }
    
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func reloadComponents() {
        picker.reloadAllComponents()
    }
}

extension IOTableViewCellSinglePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayComponets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayComponets[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.pickerDidSelected(row: row)
        
    }
 
}
