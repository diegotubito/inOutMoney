//
//  IOPersonalizarViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 16/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class IOPersonalizarViewController: UIViewController, IOPersonalizacionRubroViewContract {
    
    @IBOutlet weak var tableView : UITableView!
    
    var viewModel : IOPersonalizacionRubroViewModelContract!
    var isForEdition = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateRubro), name: .updateRubros, object: nil)
        viewModel = IOPersonalizacionRubroViewModel(withView: self, service: MLFirebaseDatabase())
        
        registerCells()
        
        viewModel.cargarRubros()
        
    }
    
    @objc func handleUpdateRubro() {
        viewModel.cargarRubros()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    
    @IBAction func nuewRubroPressed(_ sender: Any) {
        isForEdition = false
        performSegue(withIdentifier: "segue_alta_o_edicion_rubro", sender: nil)
    }
    
    func registerCells() {
        tableView.register(IOTableViewCellRubro.nib, forCellReuseIdentifier: IOTableViewCellRubro.identifier)
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func showLoading() {
        DDBarLoader.showLoading(controller: self, message: ProjectConstants.loadingText)
    }
    
    func hideLoading() {
        DDBarLoader.hideLoading()
    }
    
    func showError(_ errorMessage: String) {
        Toast.show(message: errorMessage, controller: self)
    }
    
    
    func alertMessage(title: String, message: String, indexPath: IndexPath) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertAction.Style.default, handler: { action in
            // do something like...
            self.viewModel.eliminarRubro(row: indexPath.row)
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? IOAltaEdicionRubroViewController {
            controller.viewModel = IOAltaEdicionRubroViewModel(withView: controller, isEdition: isForEdition)
        } else if let controller = segue.destination as? IODetalleRubroViewController {
            if let rubroSeleccionado = sender as? IOProjectModel.Rubro {
                controller.viewModel = IODetalleRubroViewModel(withView: controller, service: MLFirebaseDatabase(), rubroSeleccionado: rubroSeleccionado)
            }
        }
        
    }
}

extension IOPersonalizarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.rubros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellRubro.identifier, for: indexPath) as? IOTableViewCellRubro {
            
            let fecha = (viewModel.model.rubros[indexPath.row].fechaCreacion).prefix(10)
            let fechaStr = String(fecha)
            
            cell.title.text = viewModel.model.rubros[indexPath.row].descripcion
            cell.creacion.text = fechaStr
            
            var tipo = viewModel.model.rubros[indexPath.row].type
            if tipo == ProjectConstants.rubros.gastoKey {
                tipo = "Gasto"
                cell.tipo.textColor = .red
            } else {
                tipo = "Ingreso"
                cell.tipo.textColor = .blue
            }
            
            let rubro = viewModel.model.rubros[indexPath.row]
            if !rubro.isEnabled {
                cell.tipo.alpha = 0.3
                cell.tipo.textColor = UIColor.lightGray.withAlphaComponent(0.3)
                cell.registros.textColor = UIColor.lightGray.withAlphaComponent(0.3)
            }
            
            cell.tipo.text = tipo
          
            let counter = viewModel.model.rubros[indexPath.row].counter ?? 0
            cell.registros.text = String(counter)
    
            
          
            return cell
        }
        return UITableViewCell()
    }
    
    
 
}


extension IOPersonalizarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rubroSeleccionado = viewModel.model.rubros[indexPath.row]
        
        performSegue(withIdentifier: "segue_detalle_rubro", sender: rubroSeleccionado)
    }
    
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        
//        let editAction = UIContextualAction(style: .destructive, title: "Editar") { (action, view, handler) in
//            self.isForEdition = true
//            self.performSegue(withIdentifier: "segue_alta_o_edicion_rubro", sender: nil)
//        }
//        editAction.backgroundColor = UIColor.green.withAlphaComponent(0.5)
//        
//        let deleteAction = UIContextualAction(style: .destructive, title: "Borrar") { (action, view, handler) in
//            self.alertMessage(title: "Eliminar", message: "El rubro se eliminará de forma permanente", indexPath: indexPath)
//        }
//        deleteAction.backgroundColor = .red
//        
//        
//        
//        
//        
//        let configuration = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
//        configuration.performsFirstActionWithFullSwipe = false
//        return configuration
//        
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
       {
           var firstAction : UITableViewRowAction?
           var secondAction : UITableViewRowAction?
           var arrayActions = [UITableViewRowAction]()
           let registro = viewModel.model.rubros[indexPath.row]
           
        if !registro.isEnabled{
               firstAction = UITableViewRowAction(style: .default, title: "Editar", handler: { (action, indexpath) in
                    self.performSegue(withIdentifier: "segue_alta_o_edicion_rubro", sender: nil)
                   
               })
               firstAction?.backgroundColor = ProjectConstants.colors.swipeEditar
               arrayActions.append(firstAction!)
               
               secondAction = UITableViewRowAction(style: .destructive, title: "Anular") { (action, indexpath) in

                   self.viewModel.anularReestablecer(section: indexPath.section, row: indexPath.row, value: false)
                   
               }
               secondAction?.backgroundColor = ProjectConstants.colors.swipeAnular
               arrayActions.append(secondAction!)
               
           } else {
               firstAction = UITableViewRowAction(style: .default, title: "Reestablecer", handler: { (action, indexpath) in
 
                                   self.viewModel.anularReestablecer(section: indexPath.section, row: indexPath.row, value: true)

               })
               firstAction?.backgroundColor = ProjectConstants.colors.swipeReestablecer
               arrayActions.append(firstAction!)
               
               secondAction = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexpath) in
                   
                self.alertMessage(title: "Eliminar", message: "El rubro se eliminará de forma permanente", indexPath: indexPath)

               }
               secondAction?.backgroundColor = ProjectConstants.colors.swipeEliminar
               arrayActions.append(secondAction!)
               
               
           }
           
           return arrayActions
       }
    
}
