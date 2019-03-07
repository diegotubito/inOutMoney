//
//  IOBorrorRubroGastoViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 6/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOBorrarRubroGastoViewController: UIViewController, IOBorrarRubroGastoViewContract {
    
    
     var viewModel : IOBorrarRubroGastoViewModelContract!
    var buttonRemove : UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(IOTableViewCellBorrarRubroGasto.nib, forCellReuseIdentifier: IOTableViewCellBorrarRubroGasto.identifier)
 
        viewModel.loadData()
        
    
        buttonRemove = UIBarButtonItem(title: "Confirmar", style: .done, target: self, action: #selector(savePressed))
        navigationItem.rightBarButtonItem = buttonRemove
        
    }
    
    @objc func savePressed() {
        
        viewModel.eliminarRubro()
    
    }
    
    func reloadList() {
        tableView.reloadData()
    }
    
    func showSuccess() {
        Toast.show(message: "El rubro se borro correctamente", controller: self)
        performSegue(withIdentifier: "unwindSegueToCV1", sender: nil)
    }
    
    func showError(message: String) {
        Toast.show(message: message, controller: self)
    }
    
}


extension IOBorrarRubroGastoViewController: UITableViewDataSource {
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
    
    
}
