//
//  IODetalleRegistroGastoViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit


class IODetalleRegistroGastoViewController: UIViewController, IODetalleRegistroGastoViewContract {
    
    
    @IBOutlet var tableView: UITableView!
    var viewModel : IODetalleRegistroGastoViewModelContract!
    
    var cells = [UITableViewCell]()
    var descripcionCell : IOTableViewCellSingleDataEntry!
    var importeCell : IOTableViewCellSingleDataEntry!
    var fechaCell : IOTableViewCellSingleDateCell!
    var pickerCell : IOTableViewCellSinglePicker!
    
    var moreButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        moreButton = UIBarButtonItem(title: "Opciones", style: .done, target: self, action: #selector(moreTapped))
        navigationItem.rightBarButtonItem = moreButton
        
        tableView.register(IOTableViewCellSingleDataEntry.nib, forCellReuseIdentifier: IOTableViewCellSingleDataEntry.identifier)
        tableView.register(IOTableViewCellSingleDateCell.nib, forCellReuseIdentifier: IOTableViewCellSingleDateCell.identifier)
        tableView.register(IOTableViewCellSinglePicker.nib, forCellReuseIdentifier: IOTableViewCellSinglePicker.identifier)
        loadCells()
        
        selectPickerCuenta()
    }
    
    func selectPickerCuenta() {
        let childIDDebito = viewModel.model.registroRecibido.childIDCuentaDebito
        
        if let index = IOCuentaManager.cuentas.index(where: {$0.childIDCuenta == childIDDebito}) {
             selectPickerManually(posicion: index)
        }
        
    }
    
    func selectPickerManually(posicion: Int) {
        DispatchQueue.main.async {
            self.pickerCell.picker.selectRow(posicion, inComponent: 0, animated: true)
            self.pickerCell.picker.reloadAllComponents()
            
        }
    }
    
    @objc func moreTapped() {
        alertOptions()
    }
    
    func loadCells() {
        descripcionCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDataEntry.identifier) as? IOTableViewCellSingleDataEntry
        descripcionCell.titleCell.text = "Descripción"
        descripcionCell.textFieldCell.text = viewModel.model.registroRecibido.descripcion
        descripcionCell.tag = 0
        descripcionCell.delegate = self
        cells.append(descripcionCell)
        
        importeCell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleDataEntry.identifier) as? IOTableViewCellSingleDataEntry
        importeCell.textFieldCell.keyboardType = .decimalPad
        importeCell.textFieldCell.text = String(viewModel.model.registroRecibido.importe)
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
    
    func showError(_ mensaje: String) {
        Toast.show(message: mensaje, controller: self)
    }
    
    func showSuccess(_ mensaje: String) {
        Toast.show(message: mensaje, controller: self)
        navigationController?.popViewController(animated: true)
    }
    
    func getFechaInput() -> Date {
        let fecha = fechaCell.valueCell?.text!.toDate(formato: formatoDeFecha.fecha)
        return fecha!
    }
    
    func getChildIDDebitoInput() -> String {
        return IOCuentaManager.cuentas[pickerCell.picker.selectedRow(inComponent: 0)].childIDCuenta
    }
    
    func getImporteInput() -> Double {
        let aux = Double(importeCell.textFieldCell.text!)
        return aux!
    }
    
    func getDescripcion() -> String {
        return descripcionCell.textFieldCell.text!
    }
    
}

extension IODetalleRegistroGastoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
}


extension IODetalleRegistroGastoViewController: IOTableViewCellSingleDataEntryDelegate {
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


extension IODetalleRegistroGastoViewController: IOTableViewCellSinglePickerDelegate {
    func pickerDidSelected(row: Int) {
        viewModel.model.indexCuentaSeleccionada = row
        descripcionCell.textFieldCell.resignFirstResponder()
        importeCell.textFieldCell.resignFirstResponder()
    }
    
    
}

extension IODetalleRegistroGastoViewController: IOTableViewCellSingleDateCellDelegate {
    func buttonCellPressedDelegate(_ sender: UIButton) {
        print(sender.tag)
        
    }
    
    
    
}


extension IODetalleRegistroGastoViewController {
    func alertOptions() {
        let alert = UIAlertController(title: "Opciones", message: "Selecciona una opción", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Guardar cambios", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.guardarCambios()
        }))
        alert.addAction(UIAlertAction(title: "Eliminar registro", style: .destructive , handler:{ (UIAlertAction)in
            self.viewModel.eliminar()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
