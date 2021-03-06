//
//  IOLoginViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 1/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class IOLoginUsuarioViewController: UIViewController, IOLoginUserViewContract {
    
   
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var usuarioTextField: UITextField!
    @IBOutlet var siguienteOutlet: UIButton!
    @IBOutlet var fondoLoginUsuario: UIImageView!
    
    var animacionDerecha = true
    
    var viewModel : IOLoginUserViewModelContract!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        
       
     }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if RC != nil {
            let nombreFondo = RC?.configValue(forKey: IORemoteConfigKeys.login_usuario_background).stringValue
            fondoLoginUsuario.image = UIImage(named: nombreFondo ?? "")
        }
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
        usuarioTextField.text = viewModel.getUser()


       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? IOLoginContraseñaViewController {
            controller.viewModel = IOLoginPasswordViewModel(withView: controller, interactor: IOLoginFirebaseService(), user: usuarioTextField.text!)
        }
        
        if let controller = segue.destination as? IONuevoUsuarioViewController {
            controller.viewModel = IONuevoUsuarioViewModel(withView: controller, interactor: IOLoginFirebaseService())
        }
    }
    
    @IBAction func siguientePressed(_ sender: Any?) {
       
        viewModel.checkUser()
    }
    
    func goToPassword() {
        subTitleLabel.slide(fromX: subTitleLabel.frame.origin.x, toX: view.frame.width, duration: 0.3)
        
        titleLabel.slide(fromX: titleLabel.frame.origin.x, toX: view.frame.width, duration: 0.3) {
            self.performSegue(withIdentifier: "segue_to_login_contraseña", sender: nil)
            
            
        }
    }
    
    func showError(message: String) {
        print(message)
        
        usuarioTextField.textColor = UIColor.red
         usuarioTextField.shake()
    }
    
    func showSuccess(usuario: [String]) {
        usuarioTextField.textColor = UIColor.blue
        usuarioTextField.resignFirstResponder()
        goToPassword()
    }
    
     
    
    func showLoading() {
        myActivityIndicator.startAnimating()
    }
    
    func hideLoading() {
        myActivityIndicator.stopAnimating()
    }
    
    func getEmailString() -> String {
        return usuarioTextField.text!
    }
   
    @IBAction func registerPressed(_ sender: Any) {
        performSegue(withIdentifier: "seugue_nuevo_usuario", sender: nil)
    }
    
    
}

extension IOLoginUsuarioViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.checkUser()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        usuarioTextField.textColor = UIColor.black
        return true
    }
}



