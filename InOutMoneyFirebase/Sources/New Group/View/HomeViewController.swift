//
//  HomeViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    var cells = [UITableViewCell]()
    var header : TableViewCellHomeHeader!
    var cuentas : TableViewCellCuentas!
    
    var authListener : AuthStateDidChangeListenerHandle!
    var service : IOLoginFirebaseService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Resumen"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.register(TableViewCellHomeHeader.nib, forCellReuseIdentifier: TableViewCellHomeHeader.identifier)
        tableView.register(TableViewCellCuentas.nib, forCellReuseIdentifier: TableViewCellCuentas.identifier)
        
        loadCells()
        
        // Do any additional setup after loading the view, typically from a nib.
        service = IOLoginFirebaseService()
        
        authListener = Auth.auth().addStateDidChangeListener() { auth, user in
            
            UserID = user?.uid
            
            
            if user == nil {
                print("no hay usuario autenticado")
                Auth.auth().removeStateDidChangeListener(self.authListener)
                self.switchStoryboard()
                
            } else {
                print("you are logged in \(String(describing: user?.uid))")
                
            }
        }
    }
    
    @IBAction func log_out_pressed(_ sender: Any) {
        
        service.signOut(success: {
            print("sign out")
        }) {
            toast(message: "Error al cerrar sesión.")
        }
    }
    
    func switchStoryboard() {
        //Go to the HomeViewController if the login is sucessful
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "StoryboardLogin", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "IOLoginUsuarioViewController") as? IOLoginUsuarioViewController
        vc?.viewModel = IOLoginUsuarioViewModel(withView: vc!, interactor: IOLoginFirebaseService(), user: "")
        self.present(vc!, animated: true, completion: nil)
        
        
    }

    
    
    func loadCells() {
        header = tableView.dequeueReusableCell(withIdentifier: TableViewCellHomeHeader.identifier) as? TableViewCellHomeHeader
        
        header.showTotalGasto(date: Date())
        header.showTotalIngresos(date: Date())
        cells.append(header)
        
        cuentas = tableView.dequeueReusableCell(withIdentifier: TableViewCellCuentas.identifier) as? TableViewCellCuentas
        cuentas.loadTotalAccountFromFirebase()
         cells.append(cuentas)
    }
    
    func toast(message: String) {
        Toast.show(message: message, controller: self)
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
        if indexPath.row == 0 {
            return UIScreen.main.bounds.height*0.30
            
        } else {
            return UIScreen.main.bounds.height*0.2
        }
    }
}
