//
//  IOLoginViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 1/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOLoginUsuarioViewController: UIViewController, IOLoginUsuarioViewContract {
    
    
    
    
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var usuarioTextField: UITextField!
    @IBOutlet var siguienteOutlet: UIButton!
    
    var animacionDerecha = true
    
    var viewModel : IOLoginUsuarioViewModelContract!
    
    override func viewDidLoad() {
        super .viewDidLoad()
       
        disableSiguiente()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      }
    
    override func viewDidAppear(_ animated: Bool) {
        titleLabel.isHidden = false
        subTitleLabel.isHidden = false
        if animacionDerecha {
            titleLabel.slide(fromX: -view.frame.width, toX: 32, duration: 0.5)
            subTitleLabel.slide(fromX: -view.frame.width, toX: 32, duration: 0.5)
        } else {
            titleLabel.slide(fromX: view.frame.width, toX: 32, duration: 0.5)
            subTitleLabel.slide(fromX: view.frame.width, toX: 32, duration: 0.5)

        }
        
        usuarioTextField.becomeFirstResponder()


    }
    @IBAction func siguientePressed(_ sender: Any) {
        subTitleLabel.slide(fromX: subTitleLabel.frame.origin.x, toX: view.frame.width, duration: 0.3)
            
        titleLabel.slide(fromX: titleLabel.frame.origin.x, toX: view.frame.width, duration: 0.3) {
            self.performSegue(withIdentifier: "segue_to_login_contraseña", sender: nil)
            
            
        }
 
    }
    
    
    func showError(message: String) {
        print(message)
        disableSiguiente()
        usuarioTextField.shake()
    }
    
    func showSuccess(usuario: [String]) {
        enableSiguiente()
        usuarioTextField.resignFirstResponder()
    }
    
     
    func disableSiguiente() {
        siguienteOutlet.alpha = 0.3
        siguienteOutlet.isEnabled = false
    }
    
    func enableSiguiente() {
        siguienteOutlet.alpha = 1
        siguienteOutlet.isEnabled = true
    }
    
    func showLoading() {
        myActivityIndicator.startAnimating()
    }
    
    func hideLoading() {
        myActivityIndicator.stopAnimating()
    }
    
    
    
}

extension IOLoginUsuarioViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.setEmail(value: usuarioTextField.text ?? "")
        viewModel.checkUser()
        return true
    }
}


