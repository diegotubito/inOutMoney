//
//  IOTableViewCellEntradaSalida.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOTableViewCellEntradaSalida: UITableViewCell {

    @IBOutlet var periodoCell: UILabel!
    @IBOutlet var totalGastoCell: UILabel!
    @IBOutlet var fondo: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fondo.layer.cornerRadius = 10
        fondo.layer.shadowOpacity = 1
        fondo.layer.shadowColor = UIColor.gray.cgColor
        //fondo.layer.shadowRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var item: HomeProfileViewModelItem? {
        didSet {
            guard let item = item as? HomeProfileViewModelEntradaSalidaItem else {
                return
            }
            
            totalGastoCell?.text = item.totalGastos.formatoMoneda(decimales: 2, simbolo: "$")
            
            
            let periodo = item.periodoSeleccionado
            let año = periodo.año
            let mes = periodo.mes
            let nombreMes = MESES[mes]
            
            periodoCell.text = nombreMes! + " " + String(año)
        }
    }
}
