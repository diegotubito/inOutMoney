//
//  MBProductoProfileViewController.swift
//  contractExample
//
//  Created by David Diego Gomez on 24/12/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit

class MBRubrosProfileViewController: UIViewController, IOGastosViewContract {
    func reloadList() {
        tableView?.reloadData()
    }
    
    var viewModel : IOGastosViewModelContract!
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableView.automaticDimension
        
        tableView?.register(TableViewCellHeader.nib, forCellReuseIdentifier: TableViewCellHeader.identifier)
        
        viewModel.loadData()
    }
}


extension MBRubrosProfileViewController: UITableView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.section]
        switch item.type {
            
        case .rubros:
            if let item = item as? ProfileViewModeRubrosItem, let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellHeader.identifier, for: indexPath) as? TableViewCellHeader {
                let rubro = item.rubros[indexPath.row]
                cell.item = rubro
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}
