//
//  IOAltaRubroViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit


class IOAltaEdicionRubroViewController: UIViewController, IOAltaEdicionRubroViewContract {
    
   
    
    
    @IBOutlet var tableView: UITableView!
    
    var cells = [UITableViewCell]()
    var descripcionCell : IOTableViewCellSingleDataEntry!
    var typeCell : IOTableViewCellSinglePicker!
    var buttonSave : UIBarButtonItem!
    var viewModel : IOAltaEdicionRubroViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        viewModel.getTitle()
        loadCells()
        buttonSaveSetup()
    }
    
    func registerCells() {
          tableView.register(IOTableViewCellSingleDataEntry.nib, forCellReuseIdentifier: IOTableViewCellSingleDataEntry.identifier)
             tableView.register(IOTableViewCellSinglePicker.nib, forCellReuseIdentifier: IOTableViewCellSinglePicker.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.isForEdition() {
            viewModel.getDataForEdition()
        }
        descripcionCell.textField.becomeFirstResponder()
    }
    
    func buttonSaveSetup() {
        buttonSave = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(saveTapped))
  
        navigationItem.rightBarButtonItem = buttonSave
     
        viewModel.set_type_selected_index(0)
    }
    
    func showWarning(_ message: String) {
           // create the alert
           let alert = UIAlertController(title: "Atención", message: message, preferredStyle: UIAlertController.Style.alert)
           // add the actions (buttons)
           alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertAction.Style.cancel, handler: nil))
           // show the alert
           self.present(alert, animated: true, completion: nil)
    }
    
    @objc func saveTapped() {
        if viewModel.isForEdition() {
            viewModel.editarRubro(descripcion: descripcionCell.textField.text!)
        } else {
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
        typeCell.picker.selectRow(self.viewModel.model.type_selected_index ?? 0, inComponent: 0, animated: false)
            
        
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
    
    func showTitle(title: String) {
        navigationItem.title = title
    }
    
    func getDescriptionCell() -> String {
        return descripcionCell.textField.text ?? ""
    }
    
    func showDescription(_ message: String) {
        descripcionCell.textField.text = message
    }
    
    func showPickerSelection() {
        set_picker()
    }
    
}


extension IOAltaEdicionRubroViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}


extension IOAltaEdicionRubroViewController: IOTableViewCellSingleDataEntryDelegate {
    func textDidChangeDelegate(tag: Int) {
        
    }
    
    func textDidEndEditingDelegate(tag: Int) {
        
    }
    
}


extension IOAltaEdicionRubroViewController: IOTableViewCellSinglePickerDelegate {
    func pickerDidSelected(row: Int) {
       viewModel.set_type_selected_index(row)
    }
}
