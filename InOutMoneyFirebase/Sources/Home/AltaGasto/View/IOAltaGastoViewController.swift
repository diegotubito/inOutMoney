//
//  IORubrosGastosAltaViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 24/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol IOAltaGastoViewControllerDelegate {
    func nuevoRegistroIngresadoDelegate()
}
class IOAltaGastoViewController: UIViewController, IORubrosGastosAltaViewContract {
  
    
    
    var delegate : IOAltaGastoViewControllerDelegate?
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var rubroLabel : UILabel!
    
    var cells = [UITableViewCell]()
    var descripcionCell : IOTableViewCellSingleDataEntry!
    var importeCell : IOTableViewCellSingleDataEntry!
    var fechaCell : IOTableViewCellSingleDateCell!
     var pickerCell : IOTableViewCellSinglePicker!
    
    var calendario : PCMensualCustomView!
    
    var viewModel : IORubrosGastosAltaViewModelContract!
    var moreButton : UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        navigationItem.title = "Nuevo Gasto"
        
        inicializarBotonGuardar()
        registerTableViewCells()
        loadCells()
        
        viewModel.check_accounts()
        viewModel.set_cuenta_selected_index(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        rubroLabel.text = viewModel.model.rubroSeleccionado.descripcion
        
    }
    
    func inicializarBotonGuardar() {
        moreButton = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(savePressed))
        navigationItem.rightBarButtonItem = moreButton
        
    }
    
    func registerTableViewCells() {
        tableView.register(IOTableViewCellSingleDataEntry.nib, forCellReuseIdentifier: IOTableViewCellSingleDataEntry.identifier)
        tableView.register(IOTableViewCellSingleDateCell.nib, forCellReuseIdentifier: IOTableViewCellSingleDateCell.identifier)
        tableView.register(IOTableViewCellSinglePicker.nib, forCellReuseIdentifier: IOTableViewCellSinglePicker.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        set_picker()
        importeCell.textField.becomeFirstResponder()
    }
    
    func set_picker() {
        pickerCell.picker.selectRow(viewModel.model.cuenta_selected_index!, inComponent: 0, animated: true)
    }
    
    @objc func savePressed() {
        if let message = self.validateCells() {
            self.showWarning(message)
            return
        }
        
        
        // create the alert
        let alert = UIAlertController(title: "Nuevo Registro", message: "¿Estás seguro de crear un nuevo registro?", preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Guardar", style: UIAlertAction.Style.destructive, handler: { action in
            // do something like...
            self.viewModel.saveData()
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func loadCells() {
        importeCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDataEntry.identifier) as? IOTableViewCellSingleDataEntry
        importeCell.textField.keyboardType = .decimalPad
        importeCell.titleCell.text = "Importe"
        importeCell.tag = 1
        importeCell.delegate = self
        cells.append(importeCell)
        
          descripcionCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDataEntry.identifier) as? IOTableViewCellSingleDataEntry
             descripcionCell.titleCell.text = "Descripción"
             descripcionCell.tag = 0
             descripcionCell.delegate = self
             cells.append(descripcionCell)
             
        
        
        pickerCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSinglePicker.identifier) as? IOTableViewCellSinglePicker
        pickerCell.titleCell.text = "Cuenta afectada"
        pickerCell.delegate = self
        pickerCell.arrayComponets = viewModel.getDescriptionAndAmountArray()
        cells.append(pickerCell)
        
        
        fechaCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDateCell.identifier) as? IOTableViewCellSingleDateCell
        fechaCell.tag = 2
        fechaCell.titleCell.text = "Fecha del gasto"
        fechaCell.valueCell.text = Date().toString(formato: "dd-MM-yyyy")
        fechaCell.delegate = self
        cells.append(fechaCell)

    }
    
    func validateCells() -> String? {
        if let valorDouble = Double(importeCell.textField.text!) {
            if valorDouble <= 0 {
                return "El campo importe no puede ser cero"
            }
        } else {
            return "El formato importe es incorrecto."
        }
        return nil
    }
    
   
    
    
    func showError(_ message: String) {
        // create the alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in
            // do something like...
            self.navigationController?.popViewController(animated: true)
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showWarning(_ message: String) {
        // create the alert
        let alert = UIAlertController(title: "Atención", message: message, preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertAction.Style.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showSuccess() {
        self.delegate?.nuevoRegistroIngresadoDelegate()
        navigationController?.popViewController(animated: true)
    }
    
    func getFechaTextField() -> String {
        return fechaCell.valueCell.text!
    }
    
    func getDescripcionTextField() -> String {
        return descripcionCell.textField.text!
    }
    
    func getMontoTextField() -> String {
        return importeCell.textField.text!
    }
    
}

extension IOAltaGastoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
}


extension IOAltaGastoViewController: IOTableViewCellSingleDateCellDelegate {
    func buttonCellPressedDelegate(_ sender: UIButton) {
        descripcionCell.textField.resignFirstResponder()
        importeCell.textField.resignFirstResponder()
        
    }
    
   
    
}




extension IOAltaGastoViewController: IOTableViewCellSingleDataEntryDelegate {
    func textDidChangeDelegate(tag: Int) {
    }
    
    func textDidEndEditingDelegate(tag: Int) {
        
        if tag == 0 {
            importeCell.textField.becomeFirstResponder()
        } else if tag == 1 {
            importeCell.textField.resignFirstResponder()
        }
    }
    
    
}


extension IOAltaGastoViewController: IOTableViewCellSinglePickerDelegate {
    func pickerDidSelected(row: Int) {
        viewModel.set_cuenta_selected_index(row)
        descripcionCell.textField.resignFirstResponder()
        importeCell.textField.resignFirstResponder()
    }
    
    
}
