//
//  IOMoverRegistroGastoViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 7/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOMoverRegistroGastoViewController: UIViewController, IOMoverRegistroGastoViewContract {
    
    
    var viewModel : IOMoverRegistroGastoViewModelContract!
    var buttonRemove : UIBarButtonItem!
    
    @IBOutlet var myPicker: UIPickerView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(IOTableViewCellBorrarRubroGasto.nib, forCellReuseIdentifier: IOTableViewCellBorrarRubroGasto.identifier)
        
        viewModel.loadData()
        
        
        buttonRemove = UIBarButtonItem(title: "Mover", style: .done, target: self, action: #selector(moverPressed))
        navigationItem.rightBarButtonItem = buttonRemove
        
        viewModel.filtrarRubrosDisponibles()
        viewModel.seleccionarRubroPorDefecto()
        
    }
    
    
    
    
    @objc func moverPressed() {
        if viewModel.model.rubroElegido == nil || viewModel.model.registros.count == 0 {
            showError(message: "Es necesario al menos un Rubro y un Registro para poder mover.")
            return
        }
        alertConfirmar()
        
    }
    
    func reloadList() {
        tableView.reloadData()
    }
    
    func showSuccess() {
       }
    
    func showError(message: String) {
        Toast.show(message: message, controller: self)
    }
    
}


extension IOMoverRegistroGastoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.registros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellBorrarRubroGasto.identifier, for: indexPath) as? IOTableViewCellBorrarRubroGasto {
            cell.descripcionCell?.text = viewModel.model.registros[indexPath.row].descripcion
            let importe = viewModel.model.registros[indexPath.row].importe
            cell.importeCell.text = importe.formatoMoneda(decimales: 2, simbolo: "$")
            cell.fechaCell.text = viewModel.model.registros[indexPath.row].fechaGasto.toString(formato: formatoDeFecha.fecha)
            let childIDDebito = viewModel.model.registros[indexPath.row].childIDCuentaDebito
            let cuentas = IOCuentaManager.cuentas.filter({$0.childIDCuenta == childIDDebito})
            cell.cuentaCell.text = cuentas[0].descripcion
            if viewModel.model.registros[indexPath.row].isEnabled {
                cell.estadoCell.textColor = UIColor.gray
                cell.estadoCell.text = "Habilitado"
            } else {
                cell.estadoCell.textColor = UIColor.red
                cell.estadoCell.text = "Anulado"
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.model.selectedItems.append(indexPath.row)
      
        print(viewModel.model.selectedItems)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        viewModel.model.selectedItems = viewModel.model.selectedItems.filter() { $0 != indexPath.row }
        print(viewModel.model.selectedItems)
    }
}

extension IOMoverRegistroGastoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.model.rubrosDisponibles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.model.rubrosDisponibles[row].descripcion
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setRubroSeleccionado(row)
        
    }
    
}


extension IOMoverRegistroGastoViewController {
    func alertConfirmar() {
        let alert = UIAlertController(title: "Mover", message: "¿Estás seguro de mover todos los registros del rubro original al seleccionado?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Mover todos", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.moverRegistrosTodos()
            self.performSegue(withIdentifier: "unwindSegueToCV1", sender: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Mover seleccionados", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.moverRegistrosSeleccionados()
            self.performSegue(withIdentifier: "unwindSegueToCV1", sender: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
