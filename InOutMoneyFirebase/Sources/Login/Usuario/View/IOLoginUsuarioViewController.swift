//
//  IOLoginViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 1/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOLoginUsuarioViewController: UIViewController {
    override func viewDidLoad() {
        super .viewDidLoad()
        
        
    }
    @IBAction func siguientePressed(_ sender: Any) {
        performSegue(withIdentifier: "segue_to_login_contraseña", sender: nil)
    }
}
