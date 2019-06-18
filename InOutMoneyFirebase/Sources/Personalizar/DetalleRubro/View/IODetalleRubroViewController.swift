//
//  IODetalleRubroViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 17/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IODetalleRubroViewController: UIViewController, IODetalleRubroViewContract {
   
    
    var viewModel : IODetalleRubroViewModelContract!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        registerCells()
        viewModel.cargarRegistros()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = viewModel.model.rubroSeleccionado.descripcion
    }

    
    func registerCells() {
        tableView.register(IOTableViewCellSingleLabel.nib, forCellReuseIdentifier: IOTableViewCellSingleLabel.identifier)
        
    }
    func showLoading() {
        DDBarLoader.showLoading(controller: self, message: ProjectConstants.loadingText)
    }
    
    func hideLoading() {
        DDBarLoader.hideLoading()
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        Toast.show(message: message, controller: self)
    }
    
}


extension IODetalleRubroViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.model.registros.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.model.registros[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleLabel.identifier, for: indexPath) as? IOTableViewCellSingleLabel {
            
            let registro = viewModel.model.registros[indexPath.section][indexPath.row]
            
            cell.leftLabel.textColor = .black
            cell.rightLabel.textColor = .black
            if registro.isEnabled! == 0 {
                cell.leftLabel.textColor = .lightGray
                cell.rightLabel.textColor = .lightGray
            }
  
            cell.leftLabel.text = registro.descripcion
            cell.rightLabel.text = registro.importe?.formatoMoneda(decimales: 2, simbolo: "$")
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let fechaGasto = viewModel.model.registros[section][0].fechaGasto
        let fecha = fechaGasto?.toDate(formato: formatoDeFecha.fecha)
        let mes = fecha?.mes
        let año = (fecha?.año)!
        let result = MESES[mes!]! + " " + String(año)
        
        var total : Double = 0
        for i in viewModel.model.registros[section] {
            if i.isEnabled! == 1 {
                total += i.importe!
            }
        }
        return result + " " + total.formatoMoneda(decimales: 2)
    }
}

extension IODetalleRubroViewController: UITableViewDelegate {
    
}
