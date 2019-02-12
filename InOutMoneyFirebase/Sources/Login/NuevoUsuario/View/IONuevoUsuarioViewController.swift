//
//  IONuevoUsuarioViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IONuevoUsuarioViewController: UIViewController, IONuevoUsuarioViewContract {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var myIndicator: UIActivityIndicatorView!
    
    var cells = [UITableViewCell]()
    var emailCell : IOTableViewCellSingleTextField!
    var passwordCell : IOTableViewCellSingleTextField!
    var passwordRepetitionCell : IOTableViewCellSingleTextField!
    var viewModel : IONuevoUsuarioViewModelContract!
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        tableView.register(IOTableViewCellSingleTextField.nib, forCellReuseIdentifier: IOTableViewCellSingleTextField.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCells()
    }
    
    func loadCells() {
        emailCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleTextField.identifier) as? IOTableViewCellSingleTextField
        emailCell.delegate = self
        emailCell.titleLabel.text = "Dirección de correo"
        emailCell.textField.keyboardType = .emailAddress
        emailCell.textField.spellCheckingType = .no
        emailCell.textField.autocapitalizationType = .none
        emailCell.textField.autocorrectionType = .no
        emailCell.textField.font = UIFont.systemFont(ofSize: 23)
        emailCell.textField.becomeFirstResponder()
        cells.append(emailCell)
        
        passwordCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleTextField.identifier) as? IOTableViewCellSingleTextField
        passwordCell.delegate = self
        passwordCell.titleLabel.text = "Contraseña"
        passwordCell.textField.isSecureTextEntry = true
        passwordCell.textField.font = UIFont.systemFont(ofSize: 23)
        cells.append(passwordCell)

        passwordRepetitionCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleTextField.identifier) as? IOTableViewCellSingleTextField
        passwordRepetitionCell.delegate = self
        passwordRepetitionCell.titleLabel.text = "Repite la contraseña"
        passwordRepetitionCell.textField.isSecureTextEntry = true
        passwordRepetitionCell.textField.font = UIFont.systemFont(ofSize: 23)
        passwordRepetitionCell.isHidden = true
        cells.append(passwordRepetitionCell)
    }
    
    func showLoading() {
        myIndicator.startAnimating()
    }
    
    func hideLoading() {
        myIndicator.stopAnimating()
    }
    
    func showError(_ message: String) {
        print("Error Showing: \(message)")
        alertMessage(title: "Nuevo Usuario", message: message, leave: false)
        
    }
    
    func showSuccess(_ message: String) {
        print("success showing: \(message)")
        alertMessage(title: "Nuevo Usuario", message: message, leave: true)
        
        
    }
    
    @IBAction func confirmarPresionado(_ sender: Any) {
        viewModel.registerNewUser()
    }
    
    @IBAction func volverPresionado(_ sender: Any) {
        //al cancelar la operacion pongo en cero el email
        viewModel.setEmail(value: "")
        performSegue(withIdentifier: "segue_to_usuario", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? IOLoginUsuarioViewController {
            controller.viewModel = IOLoginUsuarioViewModel(withView: controller, interactor: IOLoginFirebaseService(), user: viewModel.getModel().email)
        }
    }
    
    func alertMessage(title: String, message: String, leave: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                if leave {
                    self.performSegue(withIdentifier: "segue_to_usuario", sender: nil)
                }
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension IONuevoUsuarioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}


extension IONuevoUsuarioViewController: IOTableViewCellSingelTextFieldDelegate {
    func textFieldDidFinishedDelegate(textField: UITextField) {
        if textField == emailCell.textField {
            passwordCell.textField.becomeFirstResponder()
        } else if textField == passwordCell.textField {
            passwordRepetitionCell.textField.becomeFirstResponder()
            self.passwordRepetitionCell.alpha = 0
            self.passwordRepetitionCell.isHidden = false
            UIView.animate(withDuration: 1) {
                self.passwordRepetitionCell.alpha = 1
            }
            
        } else if textField == passwordRepetitionCell.textField {
            self.passwordRepetitionCell.textField.resignFirstResponder()
        }
    }
    
    func textFieldDidChangedDelegate(textField: UITextField) {
        if textField == emailCell.textField {
            viewModel.setEmail(value: emailCell.textField.text!)
        } else if textField == passwordCell.textField {
            viewModel.setPassword(value: passwordCell.textField.text!)
            
        } else if textField == passwordRepetitionCell.textField {
            viewModel.setPasswordRepetition(value: passwordRepetitionCell.textField.text!)
        }
    }
    
    
}
