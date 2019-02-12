//
//  IOGastosCustomView.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 12/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOGastosCustomView: UIView {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var myView: UIView!
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        inicializar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        inicializar()
    }
    
    func inicializar() {
        Bundle.main.loadNibNamed("IOGastosCustomView", owner: self, options: nil)
        
        let contentFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        myView.frame = contentFrame
        addSubview(myView)
    }

}
