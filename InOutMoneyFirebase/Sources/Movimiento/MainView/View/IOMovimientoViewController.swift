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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleActualizarRegistros), name: .updateRegistros, object: nil)
          
        viewModel = IOMovimientoViewModel(withView: self, service: MLFirebaseDatabase())
        navigationItem.title = "Movimientos"
        
        registerCell()
        
        viewModel.cargarRegistros()
        
    }
    
    @objc func handleActualizarRegistros() {
        viewModel.cargarRegistros()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    func registerCell() {
        tableView.register(IOTableViewCellSingleLabel.nib, forCellReuseIdentifier: IOTableViewCellSingleLabel.identifier)
        tableView.register(IOTableViewCellHeader.nib, forCellReuseIdentifier: IOTableViewCellHeader.identifier)
    }
    
    func alertMessage(title: String, message: String, indexPath: IndexPath) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertAction.Style.default, handler: { action in
            // do something like...
            self.viewModel.eliminarRegistro(section: indexPath.section, row: indexPath.row)
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

}



extension IOMovimientoViewController: UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
   
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        var firstAction : UITableViewRowAction?
        var secondAction : UITableViewRowAction?
        var arrayActions = [UITableViewRowAction]()
        let registro = viewModel.model.registros[indexPath.section][indexPath.row]
        
        if registro.isEnabled! == 1 {
            firstAction = UITableViewRowAction(style: .default, title: "Editar", handler: { (action, indexpath) in
                
            })
            firstAction?.backgroundColor = ProjectConstants.colors.swipeEditar
            arrayActions.append(firstAction!)
            
            secondAction = UITableViewRowAction(style: .destructive, title: "Anular") { (action, indexpath) in

                self.viewModel.anularReestablecer(section: indexPath.section, row: indexPath.row, value: 0)
                
          //      self.alertMessage(title: "¿Anular?", message: "Se anulará el registro seleccionado.")
            }
            secondAction?.backgroundColor = ProjectConstants.colors.swipeAnular
            arrayActions.append(secondAction!)
            
        } else {
            firstAction = UITableViewRowAction(style: .default, title: "Reestablecer", handler: { (action, indexpath) in
                self.viewModel.anularReestablecer(section: indexPath.section, row: indexPath.row, value: 1)
            })
            firstAction?.backgroundColor = ProjectConstants.colors.swipeReestablecer
            arrayActions.append(firstAction!)
            
            secondAction = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexpath) in
                
                self.alertMessage(title: "Eliminar", message: "El registro se eliminará de forma permanente", indexPath: indexpath)
                
            }
            secondAction?.backgroundColor = ProjectConstants.colors.swipeEliminar
            arrayActions.append(secondAction!)
            
            
        }
        
        return arrayActions
    }
//
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Add") { (action, view, handler) in
//            print("Add Action Tapped")
//        }
//        deleteAction.backgroundColor = .green
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        configuration.performsFirstActionWithFullSwipe = false
//        return configuration
//    }
    
 
}

extension IOMovimientoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.model.registros.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.registros[section].count
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellHeader.identifier) as? IOTableViewCellHeader
        header?.contentView.backgroundColor = UIColor.black
        header?.myTag = section
        
        var title = ""
        if !viewModel.model.registros[section].isEmpty {
            title = viewModel.model.registros[section][0].fechaCreacion ?? "sin fecha"
        }
        
        title = String(title.prefix(10))
        let fecha = title.toDate(formato: "dd-MM-yyyy")
        let dia = Calendar.current.component(.weekday, from: fecha!)
        let nombreDelDia = NombreDias[dia-1]
        let hoy = Date().toString(formato: "dd-MM-yyyy")
        let ayerDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let ayer = ayerDate?.toString(formato: "dd-MM-yyyy")
        if hoy == title {
            title = "Hoy"
        } else if title == ayer {
            title = "Ayer"
        } else {
            title = nombreDelDia + " " + title
        }
        header?.titleLabel.text = title
        header?.titleLabel.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        return header
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellSingleLabel.identifier, for: indexPath) as? IOTableViewCellSingleLabel {
            
            let registro = viewModel.model.registros[indexPath.section][indexPath.row]
            
            cell.leftLabel.textColor = UIColor.lightGray
            cell.rightLabel.textColor = UIColor.lightGray
            if registro.isEnabled! == 0 {
                cell.leftLabel.textColor = UIColor.lightGray.withAlphaComponent(0.3)
                cell.rightLabel.textColor = UIColor.lightGray.withAlphaComponent(0.3)
            }
            
            let descripcion = registro.descripcion
            let descripcionCapitalized = descripcion?.capitalized
            cell.leftLabel.text = descripcionCapitalized
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
    
    func realoadList() {
        tableView.reloadData()
    }
    
}
