//
//  HeaderHomeCustomView.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class HeaderHomeCustomView: UIView {
    
    @IBOutlet weak var containerView : UIView!
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        inicializar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        inicializar()
    }
    
    func inicializar() {
        Bundle.main.loadNibNamed("HeaderHomeCustomView", owner: self, options: nil)
        
        containerView.frame = self.bounds
        addSubview(containerView)
        
        
    }
}
