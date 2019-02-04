//
//  IOLoginContraseñaViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 2/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOLoginContraseñaViewController: UIViewController, IOLoginPasswordViewContract {
    
   
    
    
    var viewModel : IOLoginPasswordViewModelContract!
    
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var loginOutlet: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    
     @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var contraseñaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableLogin()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleLabel.isHidden = false
        subTitleLabel.isHidden = false
        
        titleLabel.slide(fromX: -view.frame.width, toX: 32, duration: 0.5)
        subTitleLabel.slide(fromX: -view.frame.width, toX: 32, duration: 0.5)
        
        contraseñaTextField.becomeFirstResponder()
    }
    
    
    @IBAction func siguientePressed(_ sender: Any) {
        viewModel.login()
        
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
            controller.viewModel = IOLoginUsuarioViewModel(withView: controller, interactor: IOLoginFirebaseService(), user: viewModel.getUser())
        }
    }
    
    func showLoading() {
        myActivityIndicator.startAnimating()
    }
    
    func hideLoading() {
        myActivityIndicator.stopAnimating()
    }
    
    func showError(message: String) {
        print(message)
        contraseñaTextField.textColor = UIColor.red
        contraseñaTextField.shake()
    }
    
    func showSuccess() {
        performSegue(withIdentifier: "segue_to_home", sender: nil)

    }
    
    func disableLogin() {
        loginOutlet.alpha = 0.3
        loginOutlet.isEnabled = false
    }
    
    func enableLogin() {
        loginOutlet.alpha = 1
        loginOutlet.isEnabled = true
    }
    
    func getPassword() -> String {
        return passwordTextField.text!
    }
    
    
}



extension IOLoginContraseñaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(contraseñaTextField.text?.isEmpty)! {
            viewModel.login()
        } else {
            showError(message: "campo vacio")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        contraseñaTextField.textColor = UIColor.black
        
        enableLogin()
        return true
    }
}
