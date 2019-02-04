//
//  IOLoginContraseñaViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 2/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
import Foundation

class IOLoginContraseñaViewController: UIViewController, IOLoginPasswordViewContract {
    
    @IBOutlet var globo: UIView!
    @IBOutlet var triesLabel: UILabel!
    
    
    
    var viewModel : IOLoginPasswordViewModelContract!
    
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var loginOutlet: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    
     @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var contraseñaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globo.layer.cornerRadius = globo.frame.width/2
        globo.backgroundColor = UIColor.red
        globo.isHidden = true
        
        disableLogin()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleLabel.isHidden = false
        subTitleLabel.isHidden = false
        
        titleLabel.slide(fromX: -view.frame.width, toX: 32, duration: 0.5)
        subTitleLabel.slide(fromX: -view.frame.width, toX: 32, duration: 0.5)
        
     //   showNumberOfTries()
     //   fadeNumberOfTries()
        
        contraseñaTextField.becomeFirstResponder()
    }
    
    func showNumberOfTries() {
        
        globo.backgroundColor = viewModel.getBackgroundColorNumberOfTries()
        triesLabel.textColor = viewModel.getTextColorNumberOfTries()
       

    }
    
    func fadeNumberOfTries() {
        globo.isHidden = false
        triesLabel.text = viewModel.getNumberOfTries()
        globo.zoomIn(duration: 1) {
            
        }
    }
    func shakeNumberOfTries() {
        globo.shake()
    }
    
     
    
   
    
    @IBAction func siguientePressed(_ sender: Any?) {
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
      
        contraseñaTextField.textColor = UIColor.red
        contraseñaTextField.shake()
     //   dialogOKCancel(title: "Error", message: message, buttonTitle: "Entendido")
        viewModel.descontarNumberOfTries()
    }
    
    func showBlockingError() {
        let dialogo = dialogOKCancel(title: "Demasiados Intentos", message: "Demasiados intentos de login. Puedes restablecer tu contraseña si no te la acuerdas, o intenta más tarde.", buttonTitle: "Entendido")
        
        self.present(dialogo, animated: true, completion: nil)

        contraseñaTextField.resignFirstResponder()
        contraseñaTextField.isEnabled = false
        contraseñaTextField.backgroundColor = UIColor.lightGray
        contraseñaTextField.alpha = 0.5
        disableLogin()
        
        triesLabel.text = "X"
        globo.isHidden = false
        shakeNumberOfTries()
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
            siguientePressed(nil)
        } 
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        contraseñaTextField.textColor = UIColor.black
        
        enableLogin()
        return true
    }
}


func dialogOKCancel(title: String, message: String, buttonTitle: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
        switch action.style{
        case .default:
            print("default")
            
        case .cancel:
            print("cancel")
            
        case .destructive:
            print("destructive")
            
            
        }}))
    return alert
}
