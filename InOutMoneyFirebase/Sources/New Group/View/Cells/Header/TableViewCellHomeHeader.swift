//
//  TableViewCellHomeHeader.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class TableViewCellHomeHeader: UITableViewCell {

    @IBOutlet var gastoLabel: UILabel!
    @IBOutlet var gastoMesAnteriorLabel: UILabel!
    
    @IBOutlet var gastoMesAntriorActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var gastoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var plusExpenditureOutlet: UIView!
    @IBOutlet var plusIncomeOutlet: UIView!
    @IBOutlet var historyBackground: UIView!
    @IBOutlet var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plusExpenditureOutlet.layer.cornerRadius = 5
        plusIncomeOutlet.layer.cornerRadius = 5
        backgroundImage.layer.masksToBounds = true
        backgroundImage.layer.cornerRadius = historyBackground.frame.height/20
        historyBackground.layer.masksToBounds = true
        historyBackground.layer.cornerRadius = 5
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
    
    func loadGasto(mes: Int, año: Int) {
        startAnimatingActivity(activity: &gastoActivityIndicator, label: &gastoLabel)
        startAnimatingActivity(activity: &gastoMesAntriorActivityIndicator, label: &gastoMesAnteriorLabel)
        
        IOGastoManager.loadRegistersFromFirebase(mes: mes, año: año, success: {
            self.stopAnimatingActivity(activity: &self.gastoActivityIndicator, label: &self.gastoLabel)
            self.stopAnimatingActivity(activity: &self.gastoMesAntriorActivityIndicator, label: &self.gastoMesAnteriorLabel)
            let totalSpendCurrentMonth = IOGastoManager.getTotalRegistros()
            self.gastoLabel.text = totalSpendCurrentMonth.formatoMoneda(decimales: 2, simbolo: "$")
        }) { (errorMessage) in
            self.stopAnimatingActivity(activity: &self.gastoActivityIndicator, label: &self.gastoLabel)
            print(errorMessage)
            
        }
    }
    
    func stopAnimatingActivity(activity: inout UIActivityIndicatorView, label: inout UILabel) {
        activity.stopAnimating()
        label.isHidden = false
    }
    
    func startAnimatingActivity(activity: inout UIActivityIndicatorView, label: inout UILabel) {
        activity.startAnimating()
        label.isHidden = true
    }
    
}
