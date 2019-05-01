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
    
    func loadTotalAccountFromFirebase() {
        do {
            let cuentas = try IOAccountManager.instance.retrieveAccounts()
            print(cuentas as Any)
        } catch {
            let err = error as? IOAccountManager.AccountError
            if err == IOAccountManager.AccountError.empty {
                print("array empty")
            } else {
                print("standar error")
            }
        }
    }
    
}
