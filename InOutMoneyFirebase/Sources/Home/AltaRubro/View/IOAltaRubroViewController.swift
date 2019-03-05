//
//  IOAltaRubroViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOAltaRubroViewController: UIViewController, IOAltaRubroViewContract {
    @IBOutlet var tableView: UITableView!
    
    var cells = [UITableViewCell]()
    var descripcionCell : IOTableViewCellSingleDataEntry!
    var buttonSave : UIBarButtonItem!
    var viewModel : IOAltaRubroViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(IOTableViewCellSingleDataEntry.nib, forCellReuseIdentifier: IOTableViewCellSingleDataEntry.identifier)
        
        loadCells()
    
        buttonSave = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(saveTapped))
        buttonSave.isEnabled = false
        navigationItem.rightBarButtonItem = buttonSave
        
    }
    
    @objc func saveTapped() {
        if validate() {
            viewModel.guardarNuevoRubro(descripcion: descripcionCell.textFieldCell.text!)
        }
    }
    
    func loadCells() {
        descripcionCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDataEntry.identifier) as? IOTableViewCellSingleDataEntry
        descripcionCell.titleCell.text = "Descripción"
        descripcionCell.delegate = self
        cells.append(descripcionCell)
    }
    
    func success() {
        navigationController?.popViewController(animated: true)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}


extension IOAltaRubroViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
}


extension IOAltaRubroViewController: IOTableViewCellSingleDataEntryDelegate {
    func textDidChangeDelegate(tag: Int) {
        print("text changed")
    }
    
    func textDidEndEditingDelegate(tag: Int) {
        descripcionCell.textFieldCell.resignFirstResponder()
        _ = validate()
    }
    
    func validate() -> Bool {
        if descripcionCell.textFieldCell.text?.count == 0 {
             buttonSave.isEnabled = false
            return false
        }

        if (descripcionCell.textFieldCell.text?.count)! > 30 {
             buttonSave.isEnabled = false
            return false
        }
        buttonSave.isEnabled = true
        
        return true
    }
    
}
