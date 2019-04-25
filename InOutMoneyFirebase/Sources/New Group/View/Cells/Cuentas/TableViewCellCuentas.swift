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
    
    @IBOutlet var totalEfectivoLabel: UILabel!
    @IBOutlet var totalBancoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundImage.layer.cornerRadius = backgroundImage.frame.height/10
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
        MLFirebaseDatabaseService.retrieveData(path: UserID! + "/cuentas") { (response, error) in
            
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            guard response != nil else {
                print("vacio")
                return
            }
            
            print(response)
        }
    }
    
}
