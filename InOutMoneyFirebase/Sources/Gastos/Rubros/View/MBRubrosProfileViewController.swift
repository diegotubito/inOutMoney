//
//  MBProductoProfileViewController.swift
//  contractExample
//
//  Created by David Diego Gomez on 24/12/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit

class MBRubrosProfileViewController: UIViewController, MBRubrosListadoProfileViewContract {
    
    
   var viewModel : MBRubrosListadoProfileViewModelContract!
    
    @IBOutlet weak var tableView: UITableView?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableView.automaticDimension
        
        
        tableView?.register(TableViewCellProfileInfoGeneral.nib, forCellReuseIdentifier: TableViewCellProfileInfoGeneral.identifier)
        tableView?.register(TableViewCellProfileEstadistica.nib, forCellReuseIdentifier: TableViewCellProfileEstadistica.identifier)
        
        tableView?.register(TableViewCellHeader.nib, forHeaderFooterViewReuseIdentifier: TableViewCellHeader.identifier)
        
        
     
        
        viewModel.loadData()
     }
    
 
    func showLoding() {
        
    }
    
    func hideLoding() {
        
    }
    
    func reloadList() {
        tableView?.reloadData()
    }
   
    func showError(_ descripcion: String) {
        
    }
}

extension MBRubrosProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        //rows updates
        let item = viewModel.items[indexPath.section]
        switch item.type {
        case .infoGeneral:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellProfileInfoGeneral.identifier, for: indexPath) as? TableViewCellProfileInfoGeneral {
            
                cell.activityIndicatorImagenProducto.startAnimating()
                if let imagen = viewModel.items[indexPath.row].image {
                    cell.imagenProducto.image = imagen
                    cell.activityIndicatorImagenProducto.stopAnimating()
                    cell.fondoProducto.isHidden = false
                } else {
                    cell.fondoProducto.isHidden = true
                }
            
                let tap = UITapGestureRecognizer(target: self, action: #selector(stocktapped(_:)))
                cell.tag = indexPath.section
                cell.fondoStock.addGestureRecognizer(tap)
                
                
                return cell
            }
            
        case .estadistica:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellProfileEstadistica.identifier, for: indexPath) as? TableViewCellProfileEstadistica {
          
                
                
                return cell
            }
        case .header:
            break
        }
        return UITableViewCell()
    }
 
    @objc func stocktapped(_ sender: UITapGestureRecognizer) {
    
        NotificationCenter.default.post(name: .didReceiveUpdate, object: nil)
    }
    
    func toast(message: String) {
        Toast.show(message: message, controller: self)
    }
    
}


extension MBRubrosProfileViewController: UITableViewDelegate {
  
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.items[section].titleSection.isEmpty {
            return 0
        }
        return 30
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.sectionHeaderHeight = 41
    }
    
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        let altoHeader : CGFloat = 30
        
        //left label
        let leftLabel = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.width, height: altoHeader))
        leftLabel.text = viewModel.items[section].titleSection
        leftLabel.textColor = UIColor.white
        leftLabel.font = UIFont.systemFont(ofSize: 12)
        
        header.addSubview(leftLabel)
        
        //separador
        let separador = UIImageView(frame: CGRect(x: 0, y: altoHeader - 0.3, width: view.frame.width, height: 0.3))
        separador.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        header.addSubview(separador)
        
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
   
        let labelDesplegar = UILabel(frame: CGRect(x: view.frame.width - 40, y: 1, width: 40, height: altoHeader - 2))
        labelDesplegar.isUserInteractionEnabled = true
        labelDesplegar.textColor = UIColor.white
        labelDesplegar.textAlignment = .center
        labelDesplegar.font = UIFont.systemFont(ofSize: 10)
        header.addSubview(labelDesplegar)
        if viewModel.items[section].desplegable {
            labelDesplegar.backgroundColor = UIColor.lightGray
            
            if viewModel.items[section].rowCount == 0 {
                labelDesplegar.text = "↓"
            } else {
                labelDesplegar.text = "↑"
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(sectionTapped(_:)))
            labelDesplegar.tag = section
            labelDesplegar.addGestureRecognizer(tap)
        }
        
        
        return header
        
    }
    
    @objc func sectionTapped(_ sender: UITapGestureRecognizer) {
        let section = (sender.view?.tag)!
        tableView?.beginUpdates()
        
        if viewModel.items[section].rowCount == 0 {
            tableView?.insertRows(at: [IndexPath(row: 0, section: section)], with: .top)
            viewModel.items[section].rowCount = 1
        } else {
            tableView?.deleteRows(at: [IndexPath(row: 0, section: section)], with: .top)
            viewModel.items[section].rowCount = 0

        }
        tableView?.endUpdates()
        //viewModel.toggleRowState(index: section)
    }
 
}

