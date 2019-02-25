//
//  IORubrosProfileViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IORubrosProfileViewController : UIViewController, IORubrosProfileViewContract {
    
    
   
    
    @IBOutlet var tableView: UITableView!
    
    var viewModel : IORubrosProfileViewModelContract!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableView.automaticDimension
        
        
        tableView?.register(IOTableViewCellHeaderInfo.nib, forCellReuseIdentifier: IOTableViewCellHeaderInfo.identifier)
        tableView?.register(IOTableViewCellRegistrosGastos.nib, forCellReuseIdentifier: IOTableViewCellRegistrosGastos.identifier)
        tableView.register(IOTableViewCellBotonAgregarRegistro.nib, forCellReuseIdentifier: IOTableViewCellBotonAgregarRegistro.identifier)
         
        
        
        viewModel.loadData()
        
    
        
    }
    
    func reloadList() {
        tableView.reloadData()
    }
    
    func showToast(message: String) {
        Toast.show(message: message, controller: self)
    }
    
    func showFechaSeleccionada() {
        viewModel.loadData()
    }

}


extension IORubrosProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.model.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.model.items[indexPath.section]
        switch item.type {
        case .headerInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellHeaderInfo.identifier, for: indexPath) as? IOTableViewCellHeaderInfo {
                cell.delegate = self
                cell.item = item
                return cell
            }
            
        case .botonAgregarRegistro:
            if let item = item as? ProfileViewModelBotonAgregarRegistroItem, let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellBotonAgregarRegistro.identifier, for: indexPath) as? IOTableViewCellBotonAgregarRegistro {
                cell.delegate = self
                return cell
            }
            
        case .registros:
            if let item = item as? ProfileViewModelRegistrosGastosItem, let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellRegistrosGastos.identifier, for: indexPath) as? IOTableViewCellRegistrosGastos {
                let registro = item.registros[indexPath.row]
                cell.item = registro
                return cell
            }
      
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.model.items[section].sectionTitle
    }
}


extension IORubrosProfileViewController: IOTableViewCellBotonAgregarRegistroDelegate {
    func addButtonPressedDelegate() {
        performSegue(withIdentifier: "segue_to_nuevo_registro_gastos", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? IORubrosGastosAltaViewController {
            controller.delegate = self
            
            controller.viewModel = IORubrosGastosAltaViewModel(withView: controller, rubroSeleccionado: viewModel.model.rubroRecibido)
        }
        
        
    }
    
}


extension IORubrosProfileViewController: IORubrosGastosAltaViewControllerDelegate {
    func nuevoGastoIngresadoDelegate() {
        showToast(message: "Nuevo gasto ingresado")
        viewModel.loadData()
    }
    
    
}


extension IORubrosProfileViewController: IOTableViewCellHeaderInfoDelegate {
    func swipeRightDelegate() {
        viewModel.restarMesFechaSeleccionada()
    }
    
    func swipeLeftDelegate() {
        viewModel.sumarMesFechaSeleccionada()
    }
    
}
