//
//  IOLoginContraseñaViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 2/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOLoginContraseñaViewController: UIViewController {
    
     @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var contraseñaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleLabel.isHidden = false
        subTitleLabel.isHidden = false
        
        titleLabel.slide(fromX: -view.frame.width, toX: 32, duration: 0.5)
        subTitleLabel.slide(fromX: -view.frame.width, toX: 32, duration: 0.5)
        
        contraseñaTextField.becomeFirstResponder()
    }
    
    
    @IBAction func siguientePressed(_ sender: Any) {
        performSegue(withIdentifier: "segue_to_home", sender: nil)
    }
    
    @IBAction func volverPresionado(_ sender: Any) {
        subTitleLabel.slide(fromX: subTitleLabel.frame.origin.x, toX: -subTitleLabel.frame.width, duration: 0.3)
        
        titleLabel.slide(fromX: titleLabel.frame.origin.x, toX: -titleLabel.frame.width, duration: 0.3) {
            self.performSegue(withIdentifier: "segue_to_usuario", sender: nil)
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? IOLoginUsuarioViewController {
            controller.animacionDerecha = false
        }
    }
    
}
