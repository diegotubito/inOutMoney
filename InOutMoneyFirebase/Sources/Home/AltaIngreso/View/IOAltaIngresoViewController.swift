//
//  IOAltaViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 1/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol IOAltaIngresoViewControllerDelegate: class {
    func nuevoRegistrosIngresadoDelegate()
}

class IOAltaIngresoViewController : UIViewController, IOAltaIngresoViewContract {
   
    
    var viewModel : IOAltaIngresoViewModelContract!
    
    weak var delegate : IOAltaIngresoViewControllerDelegate?
    
    @IBOutlet weak var tableView : UITableView!
    
    var cells = [UITableViewCell]()
    var descripcionCell : IOTableViewCellSingleDataEntry!
    var importeCell : IOTableViewCellSingleDataEntry!
    var pickerCell : IOTableViewCellSinglePicker!
    var fechaCell : IOTableViewCellSingleDateCell!
    
    var calendario : PCMensualCustomView!
    var botonGuardar : UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        navigationItem.title = "Nuevo Ingreso"
        
        inicializarBotonGuardar()
        registerTableViewCell()
        loadCells()
        
        viewModel.check_accounts()
        viewModel.set_cuenta_selected_index(0)

        
    }
    
    func inicializarBotonGuardar() {
        botonGuardar = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(savePressed))
        navigationItem.rightBarButtonItem = botonGuardar
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        set_picker()
        descripcionCell.textFieldCell.becomeFirstResponder()
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
        descripcionCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDataEntry.identifier) as? IOTableViewCellSingleDataEntry
        descripcionCell.titleCell.text = "Descripción"
        descripcionCell.tag = 0
        descripcionCell.delegate = self
        cells.append(descripcionCell)
        
        importeCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDataEntry.identifier) as? IOTableViewCellSingleDataEntry
        importeCell.textFieldCell.keyboardType = .decimalPad
        importeCell.titleCell.text = "Importe"
        importeCell.tag = 1
        importeCell.delegate = self
        
        cells.append(importeCell)
        
        pickerCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSinglePicker.identifier) as? IOTableViewCellSinglePicker
        pickerCell.titleCell.text = "Cuenta afectada"
        pickerCell.delegate = self
        pickerCell.arrayComponets = IOCuentaManager.getDescriptionAndAmountArray()
        cells.append(pickerCell)
        
        
        fechaCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDateCell.identifier) as? IOTableViewCellSingleDateCell
        fechaCell.tag = 2
        fechaCell.titleCell.text = "Fecha del gasto"
        fechaCell.valueCell.text = Date().toString(formato: "dd-MM-yyyy")
        fechaCell.delegate = self
        cells.append(fechaCell)

    }
    
    func registerTableViewCell() {
        tableView.register(IOTableViewCellSingleDateCell.nib, forCellReuseIdentifier: IOTableViewCellSingleDateCell.identifier)
        tableView.register(IOTableViewCellSingleDataEntry.nib, forCellReuseIdentifier: IOTableViewCellSingleDataEntry.identifier)
        tableView.register(IOTableViewCellSinglePicker.nib, forCellReuseIdentifier: IOTableViewCellSinglePicker.identifier)
    }
    
    func validateCells() -> String? {
        if (descripcionCell.textFieldCell.text?.isEmpty)! {
            return "El campo descripción no puede estar vacio."
        }
        if let valorDouble = Double(importeCell.textFieldCell.text!) {
            if valorDouble <= 0 {
                return "El campo importe no puede ser ser cero."
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
        self.delegate?.nuevoRegistrosIngresadoDelegate()
        navigationController?.popViewController(animated: true)
    }
    
    func getFechaTextField() -> String {
        return fechaCell.valueCell.text!
    }
    
    func getDescripcionTextField() -> String {
        return descripcionCell.textFieldCell.text!
    }
    
    func getMontoTextField() -> String {
        return importeCell.textFieldCell.text!
    }
    
}


extension IOAltaIngresoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
}


extension IOAltaIngresoViewController: IOTableViewCellSingleDateCellDelegate {
    func buttonCellPressedDelegate(_ sender: UIButton) {
        print(sender.tag)
        descripcionCell.textFieldCell.resignFirstResponder()
        importeCell.textFieldCell.resignFirstResponder()
        
        calendario = PCMensualCustomView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 250))
        calendario.colorLabelDia = UIColor.white
        calendario.layer.cornerRadius = 250/20
        calendario.layer.borderColor = UIColor.white.cgColor
        calendario.layer.borderWidth = 2
        view.addSubview(calendario)
        
        /*    calendario.translatesAutoresizingMaskIntoConstraints = false
         
         let a = NSLayoutConstraint(item: calendario, attribute: .top, relatedBy: .equal, toItem: view.topAnchor, attribute: .topMargin, multiplier: 1, constant: 0)
         let b = NSLayoutConstraint(item: calendario, attribute: .left, relatedBy: .equal, toItem: view.leftAnchor, attribute: .left, multiplier: 1, constant: 0)
         let c = NSLayoutConstraint(item: calendario, attribute: .right, relatedBy: .equal, toItem: view.rightAnchor, attribute: .right, multiplier: 1, constant: 0)
         let d = NSLayoutConstraint(item: calendario, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height/2.5)
         
         view.addConstraints([a,b,c, d])
         */
    }
    
    
    
}




extension IOAltaIngresoViewController: IOTableViewCellSingleDataEntryDelegate {
    func textDidChangeDelegate(tag: Int) {
    }
    
    func textDidEndEditingDelegate(tag: Int) {
        
        if tag == 0 {
            importeCell.textFieldCell.becomeFirstResponder()
        } else if tag == 1 {
            importeCell.textFieldCell.resignFirstResponder()
        }
    }
    
    
}


extension IOAltaIngresoViewController: IOTableViewCellSinglePickerDelegate {
    func pickerDidSelected(row: Int) {
        viewModel.set_cuenta_selected_index(row)
        descripcionCell.textFieldCell.resignFirstResponder()
        importeCell.textFieldCell.resignFirstResponder()
    }
    
    
}
