//
//  IOResumenEntradaSalidaCV.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 26/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOResumenEntradaSalidaCV: UIView {
    @IBOutlet var myView: UIView!
    
    @IBOutlet var viewGastos: UIView!
    @IBOutlet var viewIngresos: UIView!
    @IBOutlet var globoGastos: UIImageView!
    @IBOutlet var globoIngresos: UIImageView!
    @IBOutlet var barraGastosView: UIImageView!
    @IBOutlet var barraIngresosView: UIImageView!
    override init(frame: CGRect) {
        super .init(frame: frame)
        inicializar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        inicializar()
    }
    
    func inicializar() {
        Bundle.main.loadNibNamed("IOResumenEntradaSalidaCV", owner: self, options: nil)
        let contentFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        myView.frame = contentFrame
        addSubview(myView)
        
        
    
        // set the shadow of the view's layer
        viewGastos.layer.backgroundColor = UIColor.clear.cgColor
        viewGastos.layer.shadowColor = UIColor.red.cgColor
        viewGastos.layer.shadowOffset = CGSize(width:0, height: 0)
        viewGastos.layer.shadowOpacity = 1
        viewGastos.layer.shadowRadius = 9
        
        // set the cornerRadius of the containerView's layer
        globoGastos.layer.cornerRadius = viewGastos.frame.height / 2
        globoGastos.layer.borderColor = UIColor.red.cgColor
        globoGastos.layer.borderWidth = 4
        globoGastos.layer.masksToBounds = true
        
        
        // set the shadow of the view's layer
        viewIngresos.layer.backgroundColor = UIColor.clear.cgColor
        viewIngresos.layer.shadowColor = UIColor.black.cgColor
        viewIngresos.layer.shadowOffset = CGSize(width:0, height: 0)
        viewIngresos.layer.shadowOpacity = 1
        viewIngresos.layer.shadowRadius = 9
        
        // set the cornerRadius of the containerView's layer
        globoIngresos.layer.cornerRadius = viewGastos.frame.height / 2
        globoIngresos.layer.borderColor = UIColor.darkGray.cgColor
        globoIngresos.layer.borderWidth = 4
        globoIngresos.layer.masksToBounds = true
        
        
        barraGastosView.layer.backgroundColor = UIColor.red.withAlphaComponent(1).cgColor
        barraGastosView.dropShadow(color: UIColor.black,
                                   opacity: 1,
                                   offSet: CGSize(width: 3, height: 3),
                                   radius: 3,
                                   scale: true)
        barraIngresosView.layer.backgroundColor = UIColor.blue.withAlphaComponent(1).cgColor
        barraIngresosView.dropShadow()
    }
}


extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
