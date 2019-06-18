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
    var typeCell : IOTableViewCellSinglePicker!
    var buttonSave : UIBarButtonItem!
    var viewModel : IOAltaRubroViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Nuevo Rubro"
        
        tableView.register(IOTableViewCellSingleDataEntry.nib, forCellReuseIdentifier: IOTableViewCellSingleDataEntry.identifier)
        tableView.register(IOTableViewCellSinglePicker.nib, forCellReuseIdentifier: IOTableViewCellSinglePicker.identifier)
        
        loadCells()
    
        buttonSave = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(saveTapped))
        buttonSave.isEnabled = false
    
        navigationItem.rightBarButtonItem = buttonSave
        
        viewModel.set_type_selected_index(0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        set_picker()
        descripcionCell.textField.becomeFirstResponder()
    }
    
    @objc func saveTapped() {
        if validate() {
            viewModel.guardarNuevoRubro(descripcion: descripcionCell.textField.text!)
        }
    }
    
    func loadCells() {
        descripcionCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDataEntry.identifier) as? IOTableViewCellSingleDataEntry
        descripcionCell.titleCell.text = "Descripción"
        descripcionCell.delegate = self
        cells.append(descripcionCell)
        
        typeCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSinglePicker.identifier) as? IOTableViewCellSinglePicker
        typeCell.titleCell.text = "Tipo de rubro"
        typeCell.arrayComponets = ProjectConstants.rubros.getDescripciones()
        typeCell.delegate = self
        cells.append(typeCell)
    }
    
    func success() {
        navigationController?.popViewController(animated: true)
    }
    
    func set_picker() {
        typeCell.picker.selectRow(viewModel.model.type_selected_index ?? 0, inComponent: 0, animated: true)
        
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
        _ = validate()
    }
    
    func textDidEndEditingDelegate(tag: Int) {
        descripcionCell.textField.resignFirstResponder()
        _ = validate()
    }
    
    func validate() -> Bool {
        if descripcionCell.textField.text?.count == 0 {
             buttonSave.isEnabled = false
            return false
        }

        if (descripcionCell.textField.text?.count)! > 30 {
             buttonSave.isEnabled = false
            return false
        }
        buttonSave.isEnabled = true
        
        return true
    }
    
}


extension IOAltaRubroViewController: IOTableViewCellSinglePickerDelegate {
    func pickerDidSelected(row: Int) {
       viewModel.set_type_selected_index(row)
    }
    
    
}
