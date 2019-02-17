//
//  TableViewCellProfileInfoGeneral.swift
//  contractExample
//
//  Created by David Diego Gomez on 24/12/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit

class TableViewCellProfileInfoGeneral: UITableViewCell {
    @IBOutlet var fondo: UIImageView!
    
    @IBOutlet var fondoProducto: UIView!
    @IBOutlet var imagenProducto: UIImageView!
    @IBOutlet var isActive: UILabel!
    @IBOutlet var descripcion: UILabel!
    @IBOutlet var precioVenta: UILabel!
    @IBOutlet var fondoStock: UIView!
    @IBOutlet var stockActual: UILabel!
    @IBOutlet var activityIndicatorImagenProducto: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fondo.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        fondoProducto.layer.cornerRadius = fondoStock.frame.size.height / 5
        fondoProducto.layer.borderColor = UIColor.darkGray.cgColor
        fondoProducto.layer.borderWidth = 0.5
        fondoProducto.clipsToBounds = true
        fondoProducto.layer.masksToBounds = true
        
        fondoStock.layer.cornerRadius = fondoStock.frame.size.height / 2
        fondoStock.layer.masksToBounds = true
        fondoStock.backgroundColor = UIColor.orange
        fondoStock.layer.borderColor = UIColor.darkGray.cgColor
        fondoStock.layer.borderWidth = 0.5
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(stockNotificationHandler(_:)), name: Notification.Name.didReceiveUpdate, object: nil)
  
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func stockNotificationHandler(_ sender: Notification) {
        
   
        fondoStock.buttonAnimation()
     //   self.fondoStock.shake()
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
