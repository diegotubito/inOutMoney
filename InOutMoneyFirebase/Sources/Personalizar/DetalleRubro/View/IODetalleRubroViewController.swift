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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleActualizarRubros), name: .updateRubros, object: nil)
        
        
        registerCells()
        viewModel.cargarRegistros()
    
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = viewModel.model.rubroSeleccionado.descripcion
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
     }

    @objc func handleActualizarRubros() {
        viewModel.cargarRegistros()
    }
    
    func registerCells() {
        tableView.register(IODetalleRubroCell.nib, forCellReuseIdentifier: IODetalleRubroCell.identifier)
        tableView.register(IOTableViewCellDetalleRubroHeader.nib, forCellReuseIdentifier: IOTableViewCellDetalleRubroHeader.identifier)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IODetalleRubroCell.identifier, for: indexPath) as? IODetalleRubroCell {
        
            let registro = viewModel.model.registros[indexPath.section][indexPath.row]
             cell.leftLabel.textColor = .lightGray
            cell.rightLabel.textColor = .lightGray
            if registro.isEnabled! == 0 {
                cell.leftLabel.textColor = .darkGray
                cell.rightLabel.textColor = .darkGray
            }
        
            cell.leftLabel.text = "No hay descripción."
            if let descripcion = registro.descripcion, !descripcion.isEmpty {
                cell.leftLabel.text = descripcion
            }
            cell.rightLabel.text = registro.importe?.formatoMoneda(decimales: 2, simbolo: "$")
            
            cell.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellDetalleRubroHeader.identifier) as? IOTableViewCellDetalleRubroHeader
        header?.contentView.backgroundColor = UIColor.black
        
        header?.leftLabel.text = getFechaForHeader(section: section)
        header?.rightLabel.text = getTotalByMonth(section: section)
        
        header?.leftLabel.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        header?.rightLabel.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        return header
    }
    
    func getFechaForHeader(section: Int) -> String {
        let fechaGasto = viewModel.model.registros[section][0].fechaGasto
        let fecha = fechaGasto?.toDate(formato: formatoDeFecha.fecha)
        let mes = fecha?.mes
        let año = (fecha?.año)!
        let result = MESES[mes!]! + " " + String(año)
        
        return result
    }
    
    func getTotalByMonth(section: Int) -> String {
        var result : Double = 0
        for i in viewModel.model.registros[section] {
            if i.isEnabled! == 1 {
                result += i.importe!
            }
        }
        return result.formatoMoneda(decimales: 2, simbolo: "$")
    }
   
}

extension IODetalleRubroViewController: UITableViewDelegate {
 
}
