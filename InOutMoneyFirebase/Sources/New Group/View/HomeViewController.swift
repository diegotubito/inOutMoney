//
//  HomeViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    var cells = [UITableViewCell]()
    var header : TableViewCellHomeHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(TableViewCellHomeHeader.nib, forCellReuseIdentifier: TableViewCellHomeHeader.identifier)
        
        
        
        loadCells()
        
       
        
    }
    
    func loadCells() {
        header = tableView.dequeueReusableCell(withIdentifier: TableViewCellHomeHeader.identifier) as? TableViewCellHomeHeader
        
        header.loadGasto(mes: 4, año: 2019)
        cells.append(header)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height*0.4
    }
}
