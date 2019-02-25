//
//  PCDiaCustomView.swift
//  PremiumCalendar
//
//  Created by David Diego Gomez on 4/1/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

extension Notification.Name {
    //notificacion antes de cerrar la aplicacion
    static let dayDidTouchNotification = Notification.Name("dayDidTouchNotification")
}

protocol PCDiaCustomViewDelegate {
    func didTouched(fila: Int, columna: Int)
}

class PCDiaCustomView: UIView {
    
    var fila : Int!
    var columna : Int!
    var labelCentral : UILabel!
   // var colorLabelCentral = UIColor.white
   // var fuenteLabelCentral: UIFont = UIFont.systemFont(ofSize: 12)
    var fondoSeleccion : UIImageView!
    var textoLabelCentral : String!
    var fechaString : String = ""
    var atributos : PCMensualDayAttribute!
    
    var delegate : PCDiaCustomViewDelegate?
    
    
  
      
    var radio: CGFloat = 0 {
        didSet {
            layer.cornerRadius = radio
        }
    }
    
    var bordeColor : UIColor = UIColor.black {
        didSet {
            layer.borderColor = bordeColor.cgColor
        }
    }
    
    var fondoDia : UIColor = UIColor.blue {
        didSet {
            layer.backgroundColor = fondoDia.cgColor
        }
    }
    
    var bordeAncho : CGFloat = 0 {
        didSet {
            layer.borderWidth = bordeAncho
        }
    }

    override init(frame: CGRect) {
        super .init(frame: frame)
        inicializar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        inicializar()
    }
    
    
    func inicializar() {
        
         let contentFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        frame = contentFrame
        
        isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        
        
        dibujar()
    }
    
   
    
    @objc func viewTapped() {
        let valor = (fila, columna)
        NotificationCenter.default.post(name: .dayDidTouchNotification, object: valor)
        self.delegate?.didTouched(fila: fila!, columna: columna!)
    }
    
    func dibujar() {
        
        DispatchQueue.main.async {
            self.backgroundColor = self.fondoDia
            self.dibujarFondoSeleccion()
            self.dibujarLabelCentral()
        }
    }
    
 
    func dibujarFondoSeleccion() {
        var dimension = frame.height
        if frame.width < frame.height {
            dimension = frame.width
        }
        fondoSeleccion = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        fondoSeleccion.backgroundColor = UIColor.clear
        fondoSeleccion.layer.cornerRadius = dimension/2
        fondoSeleccion.layer.masksToBounds = true
        
        addSubview(fondoSeleccion)
        
        fondoSeleccion.translatesAutoresizingMaskIntoConstraints = false
        
        let c1 = NSLayoutConstraint(item: fondoSeleccion, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: fondoSeleccion, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let c3 = NSLayoutConstraint(item: fondoSeleccion, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: dimension)
        let c4 = NSLayoutConstraint(item: fondoSeleccion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: dimension)
        self.addConstraints([c1, c2, c3, c4])
        
        
    }
    
    func dibujarLabelCentral() {
        labelCentral = UILabel()
        labelCentral.text = textoLabelCentral
        labelCentral.textAlignment = .center
        self.addSubview(labelCentral)
        
        labelCentral.translatesAutoresizingMaskIntoConstraints = false
        
        let v = NSLayoutConstraint(item: labelCentral, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let h = NSLayoutConstraint(item: labelCentral, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([v, h])
        
        
  }
    

}
