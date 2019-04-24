//
//  TableViewCellHomeHeader.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class TableViewCellHomeHeader: UITableViewCell {
    @IBOutlet var totalIngresoMes: UILabel!
    @IBOutlet var totalIngresoMesAnterior: UILabel!
    @IBOutlet var totalIngresoMesAnteriorAnterior: UILabel!
    
    
    @IBOutlet var activityIndicatorIngresoMesAnteriorAnterior: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorIngresoMesAnterior: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorIngresoMes: UIActivityIndicatorView!
    
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
    
    func showTotalGasto(date: Date) {
        
        let mes = date.mes
        let año = date.año
        let restarUnMes = Calendar.current.date(byAdding: .month, value: -1, to: date)
        let mesAnterior = restarUnMes?.mes
        let añoAnterior = restarUnMes?.año
        
        let restarDosMes = Calendar.current.date(byAdding: .month, value: -2, to: date)
        let mesAnteriorAnterior = restarDosMes?.mes
        let añoAnteriorAnterior = restarDosMes?.año
        
        
        startAnimatingActivity(activity: &activityIndicatorGastoMes, label: &totalGastoMes)
        
        IOGastoManager.loadGastosFromFirebase(mes: mes, año: año, success: {
            self.stopAnimatingActivity(activity: &self.activityIndicatorGastoMes, label: &self.totalGastoMes)
             let totalSpendCurrentMonth = IOGastoManager.getTotalRegistros()
            self.totalGastoMes.text = totalSpendCurrentMonth.formatoMoneda(decimales: 2, simbolo: "$")
        }) { (errorMessage) in
            self.stopAnimatingActivity(activity: &self.activityIndicatorGastoMes, label: &self.totalGastoMes)
            print(errorMessage)
            
        }
        
        startAnimatingActivity(activity: &activityIndicatorGastoMesAnterior, label: &totalGastoMesAnterior)
        IOGastoManager.loadGastosFromFirebase(mes: mesAnterior!, año: añoAnterior!, success: {
            self.stopAnimatingActivity(activity: &self.activityIndicatorGastoMesAnterior, label: &self.totalGastoMesAnterior)
            let totalSpendCurrentMonth = IOGastoManager.getTotalRegistros()
            self.totalGastoMesAnterior.text = totalSpendCurrentMonth.formatoMoneda(decimales: 2, simbolo: "$")
        }) { (errorMessage) in
            self.stopAnimatingActivity(activity: &self.activityIndicatorGastoMesAnterior, label: &self.totalGastoMesAnterior)
            print(errorMessage)
            
        }
        
        startAnimatingActivity(activity: &activityIndicatorGastoMesAnteriorAnterior, label: &totalGastoMesAnteriorAnterior)
        IOGastoManager.loadGastosFromFirebase(mes: mesAnteriorAnterior!, año: añoAnteriorAnterior!, success: {
            self.stopAnimatingActivity(activity: &self.activityIndicatorGastoMesAnteriorAnterior, label: &self.totalGastoMesAnteriorAnterior)
            let totalSpendCurrentMonth = IOGastoManager.getTotalRegistros()
            self.totalGastoMesAnteriorAnterior.text = totalSpendCurrentMonth.formatoMoneda(decimales: 2, simbolo: "$")
        }) { (errorMessage) in
            self.stopAnimatingActivity(activity: &self.activityIndicatorGastoMesAnteriorAnterior, label: &self.totalGastoMesAnteriorAnterior)
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


extension TableViewCellHomeHeader {
    func showTotalIngresos(date: Date) {
        
        let mes = date.mes
        let año = date.año
        let restarUnMes = Calendar.current.date(byAdding: .month, value: -1, to: date)
        let mesAnterior = restarUnMes?.mes
        let añoAnterior = restarUnMes?.año
        
        let restarDosMes = Calendar.current.date(byAdding: .month, value: -2, to: date)
        let mesAnteriorAnterior = restarDosMes?.mes
        let añoAnteriorAnterior = restarDosMes?.año
        
        
        startAnimatingActivity(activity: &activityIndicatorIngresoMes, label: &totalIngresoMes)
        
        IOGastoManager.loadGastosFromFirebase(mes: mes, año: año, success: {
            self.stopAnimatingActivity(activity: &self.activityIndicatorIngresoMes, label: &self.totalIngresoMes)
            let totalSpendCurrentMonth = IOIngresoManager.getTotalRegistros()
            self.totalIngresoMes.text = totalSpendCurrentMonth.formatoMoneda(decimales: 2, simbolo: "$")
        }) { (errorMessage) in
            self.stopAnimatingActivity(activity: &self.activityIndicatorIngresoMes, label: &self.totalIngresoMes)
            print(errorMessage)
            
        }
        
        startAnimatingActivity(activity: &activityIndicatorIngresoMesAnterior, label: &totalIngresoMesAnterior)
        IOGastoManager.loadGastosFromFirebase(mes: mesAnterior!, año: añoAnterior!, success: {
            self.stopAnimatingActivity(activity: &self.activityIndicatorIngresoMesAnterior, label: &self.totalIngresoMesAnterior)
            let totalSpendCurrentMonth = IOIngresoManager.getTotalRegistros()
            self.totalIngresoMesAnterior.text = totalSpendCurrentMonth.formatoMoneda(decimales: 2, simbolo: "$")
        }) { (errorMessage) in
            self.stopAnimatingActivity(activity: &self.activityIndicatorIngresoMesAnterior, label: &self.totalIngresoMesAnterior)
            print(errorMessage)
            
        }
        
        startAnimatingActivity(activity: &activityIndicatorIngresoMesAnteriorAnterior, label: &totalIngresoMesAnteriorAnterior)
        IOGastoManager.loadGastosFromFirebase(mes: mesAnteriorAnterior!, año: añoAnteriorAnterior!, success: {
            self.stopAnimatingActivity(activity: &self.activityIndicatorIngresoMesAnteriorAnterior, label: &self.totalIngresoMesAnteriorAnterior)
            let totalSpendCurrentMonth = IOIngresoManager.getTotalRegistros()
            self.totalIngresoMesAnteriorAnterior.text = totalSpendCurrentMonth.formatoMoneda(decimales: 2, simbolo: "$")
        }) { (errorMessage) in
            self.stopAnimatingActivity(activity: &self.activityIndicatorIngresoMesAnteriorAnterior, label: &self.totalIngresoMesAnteriorAnterior)
            print(errorMessage)
            
        }
    }
}
