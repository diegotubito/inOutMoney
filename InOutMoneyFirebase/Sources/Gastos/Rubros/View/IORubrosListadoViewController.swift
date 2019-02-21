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
        
        viewModel.loadData()
    }
    
    func reloadList() {
        tableView.reloadData()
    }
}
