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
        
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableView.automaticDimension
        
        
        tableView?.register(IOTableViewCellHeaderInfo.nib, forCellReuseIdentifier: IOTableViewCellHeaderInfo.identifier)
         
        
        
        viewModel.loadData()
        
    }
    
    func reloadList() {
        tableView.reloadData()
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
        
        //rows updates
        let item = viewModel.model.items[indexPath.section]
        switch item.type {
        case .headerInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellHeaderInfo.identifier, for: indexPath) as? IOTableViewCellHeaderInfo {
                
                let dato = viewModel.model.items[indexPath.row].json
                cell.titleLabel.text = "Ene"
                cell.subTitleLabel.text = "199"
                
                return cell
            }
            
        case .registros:
            break
        case .botonAgregarRegistro:
            break
        }
        return UITableViewCell()
    }
    
}


extension IORubrosProfileViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.model.items[section].titleSection.isEmpty {
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
        //titulo
        let tituloLabel = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.width, height: altoHeader))
        tituloLabel.text = viewModel.model.items[section].titleSection
        tituloLabel.textColor = UIColor.white
        tituloLabel.font = UIFont.systemFont(ofSize: 12)
        
        header.addSubview(tituloLabel)
        
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
     //   if viewModel.model.items[section].desplegable {
            labelDesplegar.backgroundColor = UIColor.lightGray
            labelDesplegar.text = "↑↓"
            
          
       // }
        
        
        return header
        
    }
    
}
