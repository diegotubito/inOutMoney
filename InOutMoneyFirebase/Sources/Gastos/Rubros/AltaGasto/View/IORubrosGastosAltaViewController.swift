//
//  IORubrosGastosAltaViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 24/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

protocol IORubrosGastosAltaViewControllerDelegate {
    func nuevoGastoIngresadoDelegate()
}
class IORubrosGastosAltaViewController: UIViewController, IORubrosGastosAltaViewContract {
    var delegate : IORubrosGastosAltaViewControllerDelegate?
    @IBOutlet var tableView: UITableView!
    var cells = [UITableViewCell]()
    var descripcionCell : IOTableViewCellSingleDataEntry!
    var importeCell : IOTableViewCellSingleDataEntry!
    var fechaCell : IOTableViewCellSingleDateCell!
     var pickerCell : IOTableViewCellSinglePicker!
    
    var calendario : PCMensualCustomView!
    
    var viewModel : IORubrosGastosAltaViewModelContract!
    var moreButton : UIBarButtonItem!
    
    
    override func viewDidLoad() {
        moreButton = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(moreTapped))
        navigationItem.rightBarButtonItem = moreButton
        
        super.viewDidLoad()
        tableView.register(IOTableViewCellSingleDataEntry.nib, forCellReuseIdentifier: IOTableViewCellSingleDataEntry.identifier)
        tableView.register(IOTableViewCellSingleDateCell.nib, forCellReuseIdentifier: IOTableViewCellSingleDateCell.identifier)
         tableView.register(IOTableViewCellSinglePicker.nib, forCellReuseIdentifier: IOTableViewCellSinglePicker.identifier)
        loadCells()
    }
    
    @objc func moreTapped() {
        if let message = self.validateCells() {
            self.showError(message)
            return
        }
        
        
        // create the alert
        let alert = UIAlertController(title: "Nuevo Registro", message: "¿Estás seguro de crear un nuevo registro?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Guardar", style: UIAlertAction.Style.destructive, handler: { action in
            
            // do something like...
            
            
            self.saveData()
            
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
    
    func saveData() {
        
        
        
        
        let childIDRubro = viewModel.model.rubroSeleccionado.childID
        let keyFecha = fechaCell.valueCell?.text!.toDate(formato: formatoDeFecha.fecha)
        let mes = keyFecha?.mes
        let año = keyFecha?.año
        let keyFechaString = MESES[mes!]! + String(año!)
        let queryByTypeMonthYear = childIDRubro + "#" + keyFechaString
        let queryByTypeYear = childIDRubro + "#" + String(año!)
        let queryByMonthYear = keyFechaString
        let queryByYear = String(año!)
        let childIDDebito = IOCuentaManager.cuentas[viewModel.model.codigoCuentaSeleccionada].childIDCuenta
        let importe = Double(importeCell.textFieldCell.text!)!
        
        let path = UserID! + "/gastos/registros"
        
        
        let datos = ["queryByTypeMonthYear" : queryByTypeMonthYear,
                     "queryByTypeYear" : queryByTypeYear,
                     "queryByMonthYear" : queryByMonthYear,
                     "queryByYear" : queryByYear,
                     "childIDRubro" : childIDRubro,
                     "isEnabled" : 1,
                     "childIDDebito" : childIDDebito,
                     "descripcion" : descripcionCell.textFieldCell.text!,
                     "fechaGasto" : fechaCell.valueCell.text!,
                     "fechaCreacion" : Date().toString(formato: formatoDeFecha.fechaConHora),
                     "importe" : importe] as [String : Any]
        
        MLFirebaseDatabaseService.setDataWithAutoId(path: path, diccionario: datos, success: { (ref) in
             MLFirebaseDatabaseService.setTransaction(path: UserID! + "/cuentas/" + childIDDebito, keyName: "saldo", incremento: -importe, success: {
                self.showSuccess("Nuevo gasto guardado.")
            }, fail: { (error) in
                self.showError("Algo salio mal.")
            })
            
        }) { (error) in
            self.showError(error?.localizedDescription ?? "Error")
        }
 
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
    
    
    func showSuccess(_ message: String) {
        self.delegate?.nuevoGastoIngresadoDelegate()
        navigationController?.popViewController(animated: true)
    }
}

extension IORubrosGastosAltaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
}


extension IORubrosGastosAltaViewController: IOTableViewCellSingleDateCellDelegate {
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




extension IORubrosGastosAltaViewController: IOTableViewCellSingleDataEntryDelegate {
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


extension IORubrosGastosAltaViewController: IOTableViewCellSinglePickerDelegate {
    func pickerDidSelected(row: Int) {
        viewModel.model.codigoCuentaSeleccionada = row
        descripcionCell.textFieldCell.resignFirstResponder()
        importeCell.textFieldCell.resignFirstResponder()
    }
    
    
}
