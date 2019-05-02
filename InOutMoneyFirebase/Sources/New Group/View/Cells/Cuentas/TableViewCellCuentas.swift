//
//  TableViewCellCuentas.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 23/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class TableViewCellCuentas: UITableViewCell {
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var imagenEfectivo: UIImageView!
    @IBOutlet var totalEfectivoLabel: UILabel!
    @IBOutlet var totalBancoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundImage.layer.cornerRadius = backgroundImage.frame.height/10
        
        let tapEfectivo = UITapGestureRecognizer(target: self, action: #selector(imagenEfectivoPresionado(_:)))
        tapEfectivo.numberOfTapsRequired = 1
        imagenEfectivo.isUserInteractionEnabled = true
        imagenEfectivo.addGestureRecognizer(tapEfectivo)
    }
    
    @objc func imagenEfectivoPresionado(_ sender: UITapGestureRecognizer) {
        print("toque")
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
    
    func mostrarTotalCuentas() {
        IOCuentaManager.loadCuentasFromFirebase(success: {
            if IOCuentaManager.cuentas.count == 2 {
                let efectivo = IOCuentaManager.cuentas[1].saldo
                let banco = IOCuentaManager.cuentas[0].saldo
                self.totalEfectivoLabel.text = efectivo.formatoMoneda(decimales: 2, simbolo: "$")
                
                self.totalBancoLabel.text = banco.formatoMoneda(decimales: 2, simbolo: "$")
            }
        }, fail: { (errorMessage) in
            print(errorMessage)
        })
        
    }
    
}
