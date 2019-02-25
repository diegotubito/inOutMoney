//
//  IORubrosListadoViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 21/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IORubrosListadoViewController: UIViewController, IORubrosListadoViewContract {
   
    @IBOutlet var tableView: UITableView!
    
    var viewModel : IORubrosListadoViewModelContract!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        tableView.register(IOTableViewCellRubrosListado.nib, forCellReuseIdentifier: IOTableViewCellRubrosListado.identifier)
        
        viewModel.loadData()

     }
    
     
    func reloadList() {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super .prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? IORubrosProfileViewController {
            controller.viewModel = IORubrosProfileViewModel(withView: controller, rubroSeleccionado: viewModel.model.listado[(tableView.indexPathForSelectedRow?.row)!])
        }
    }
    
    func showToast(message: String) {
        Toast.show(message: message, controller: self)
    }
}


extension IORubrosListadoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.listado.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellRubrosListado.identifier, for: indexPath) as? IOTableViewCellRubrosListado {
            
            cell.descripcionLabel.text = viewModel.model.listado[indexPath.row].descripcion
            return cell
        }
        return UITableViewCell()
    }
    
    
}


extension IORubrosListadoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segue_to_rubro_profile", sender: nil)
    }
    
    
}
