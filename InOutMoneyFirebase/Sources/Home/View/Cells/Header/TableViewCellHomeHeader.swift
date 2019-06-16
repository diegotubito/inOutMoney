//
//  TableViewCellHomeHeader.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol TabaleViewCellHomeHeaderDelegate {
    func buttonPressed(sender: TableViewCellHomeHeader.ButtonType)
}

class TableViewCellHomeHeader: UITableViewCell {
    
    var delegate :TabaleViewCellHomeHeaderDelegate?
    
    @IBOutlet var totalIngresoMes: UILabel!
    @IBOutlet var totalIngresoMesAnterior: UILabel!
    @IBOutlet var totalIngresoMesAnteriorAnterior: UILabel!
    
    
    @IBOutlet var activityIndicatorIngresoMesAnteriorAnterior: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorIngresoMesAnterior: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorIngresoMes: UIActivityIndicatorView!
    @IBOutlet var nombreMes: UILabel!
    @IBOutlet var nombreMesAnterior: UILabel!
    @IBOutlet var nombreMesAnteriorAnterior: UILabel!
    
    @IBOutlet var totalGastoMes: UILabel!
    @IBOutlet var totalGastoMesAnterior: UILabel!
    @IBOutlet var totalGastoMesAnteriorAnterior: UILabel!
    
    @IBOutlet var activityIndicatorGastoMesAnteriorAnterior: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorGastoMesAnterior: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorGastoMes: UIActivityIndicatorView!
    @IBOutlet var plusExpenditureOutlet: UIView!
    @IBOutlet var plusIncomeOutlet: UIView!
    @IBOutlet var historyBackground: UIView!
    @IBOutlet var backgroundImage: UIImageView!
    
    enum ButtonType {
        case gasto
        case ingreso
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plusExpenditureOutlet.layer.cornerRadius = plusExpenditureOutlet.frame.height/10
        plusIncomeOutlet.layer.cornerRadius = plusIncomeOutlet.frame.height/10
        backgroundImage.layer.masksToBounds = true
        backgroundImage.layer.cornerRadius = backgroundImage.frame.height/10
        historyBackground.layer.masksToBounds = true
        historyBackground.layer.cornerRadius = historyBackground.frame.height/10
        historyBackground.layer.borderColor = UIColor.lightGray.cgColor
        historyBackground.layer.borderWidth = 1
        
        setBotonGasto()
        setBotonIngreso()
        
        
    }
 
    
    func setBotonIngreso() {
        plusIncomeOutlet.isUserInteractionEnabled = true
        let tapIncome = UITapGestureRecognizer(target: self, action: #selector(nuevoIngresoPresionado(_:)))
        plusIncomeOutlet.addGestureRecognizer(tapIncome)
        
    }
    
    func setBotonGasto() {
        plusExpenditureOutlet.isUserInteractionEnabled = true
        let tapExpense = UITapGestureRecognizer(target: self, action: #selector(nuevoGastoPresionado(_:)))
        plusExpenditureOutlet.addGestureRecognizer(tapExpense)
        
    }
    
    func enableActions() {
        plusIncomeOutlet.isUserInteractionEnabled = true
        plusIncomeOutlet.alpha = 1
        plusExpenditureOutlet.isUserInteractionEnabled = true
        plusExpenditureOutlet.alpha = 1
    }
    
    func disableActions() {
        plusIncomeOutlet.isUserInteractionEnabled = false
        plusIncomeOutlet.alpha = 0.3
        plusExpenditureOutlet.isUserInteractionEnabled = false
        plusExpenditureOutlet.alpha = 0.3

    }
   
    @objc func nuevoGastoPresionado(_ sender: UITapGestureRecognizer) {
        self.delegate?.buttonPressed(sender: .gasto)
    }
    
    @objc func nuevoIngresoPresionado(_ sender: UITapGestureRecognizer) {
        self.delegate?.buttonPressed(sender: .ingreso)
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
