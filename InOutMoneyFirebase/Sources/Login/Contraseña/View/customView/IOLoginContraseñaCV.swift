//
//  IOLoginContraseñaCV.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 2/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOLoginContraseñaCV: UIView {
    @IBOutlet var myView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inicializar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inicializar()
    }
    
    func inicializar() {
        Bundle.main.loadNibNamed("IOLoginContraseñaCV", owner: self, options: nil)
        
        let contentFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        myView.frame = contentFrame
        addSubview(myView)
        
             
    }

}
