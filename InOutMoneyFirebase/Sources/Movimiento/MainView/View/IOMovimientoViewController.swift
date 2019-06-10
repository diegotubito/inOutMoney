//
//  IOMovimientoViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 2/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOMovimientoViewController: UIViewController, IOMovimientoViewContract {
   
    @IBOutlet var tableView: UITableView!
    
    var viewModel : IOMovimientoViewModelContract!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = IOMovimientoViewModel(withView: self, service: MLFirebaseDatabase())
        navigationItem.title = "Movimientos"
        
        registerCell()
        
        viewModel.cargarRegistros()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    func registerCell() {
        tableView.register(IOTableViewCellSingleLabel.nib, forCellReuseIdentifier: IOTableViewCellSingleLabel.identifier)
    }

}

extension IOMovimientoViewController: UITableViewDelegate {
    
}

extension IOMovimientoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.model.registros.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.registros[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title = ""
        if viewModel.model.registros[section].count != 0 {
            title = viewModel.model.registros[section][0].fechaCreacion ?? "sin fecha"
        }
        return title
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleLabel.identifier, for: indexPath) as? IOTableViewCellSingleLabel {
            
            cell.leftLabel.text = viewModel.model.registros[indexPath.section][indexPath.row].descripcion
            cell.rightLabel.text = viewModel.model.registros[indexPath.section][indexPath.row].importe?.formatoMoneda(decimales: 2, simbolo: "$")
            
            return cell
        }
        
        return UITableViewCell()
    }
   
}

//Conform Protocol
extension IOMovimientoViewController {
    func showError(_ errorMessage: String) {
        Toast.show(message: errorMessage, controller: self)
    }
    
    func showSuccess() {
        tableView.reloadData()
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    
}
