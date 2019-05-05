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
        
        navigationItem.title = "Home"
        
        //boton log out
        let botonLogOut = UIBarButtonItem(image: #imageLiteral(resourceName: "log-out").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(buttonLogOutPressed))
        navigationItem.rightBarButtonItem = botonLogOut
        
        //boton nuevo rubro gasto
        let botonNuevoRubroGasto = UIBarButtonItem(image: #imageLiteral(resourceName: "addButton").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(botonNuevoRubroGastoPressed))
        navigationItem.rightBarButtonItem = botonNuevoRubroGasto
        
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.register(TableViewCellHomeHeader.nib, forCellReuseIdentifier: TableViewCellHomeHeader.identifier)
        tableView.register(TableViewCellCuentas.nib, forCellReuseIdentifier: TableViewCellCuentas.identifier)
        
        
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
                
                //check if this is the first time app execution
                self.loadCells()
                self.tableView.reloadData()
                
                IORubroManager.loadRubrosFromFirebase(success: {
                    print("tengo los rubros")
                }, fail: { (errorMessage) in
                    print(errorMessage)
                })
        
               
                
//                 do {
//                    try IOCuentaManager.createDefaultAccountsToFirebase(path: UserID! + "/cuentas")
//                } catch {
//                    print(error.localizedDescription)
//                }
            }
        }
    }
  
    @objc func buttonLogOutPressed() {
        
        service.signOut(success: {
            print("sign out")
        }) {
            toast(message: "Error al cerrar sesión.")
        }
    }
    
    @objc func botonNuevoRubroGastoPressed() {
        
        performSegue(withIdentifier: "segue_rubro_gasto", sender: nil)
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
         header.delegate = self
        cells.append(header)
        
        cuentas = tableView.dequeueReusableCell(withIdentifier: TableViewCellCuentas.identifier) as? TableViewCellCuentas
        cuentas.mostrarTotalCuentas()
          cells.append(cuentas)
    }
    
    func toast(message: String) {
        Toast.show(message: message, controller: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super .prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? IOLoginUsuarioViewController {
            controller.viewModel = IOLoginUsuarioViewModel(withView: controller, interactor: IOLoginFirebaseService(), user: "")
        }
        
        if let controller = segue.destination as? IORubrosGastosAltaViewController {
            if let object = sender as? IORubroManager.Rubro {
                controller.viewModel = IORubrosGastosAltaViewModel(withView: controller, rubroSeleccionado: object)
            }
        
        }
        
        if let controller = segue.destination as? IOAltaRubroViewController {
            controller.viewModel = IOAltaRubroViewModel(withView: controller)
        }
    
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


extension HomeViewController: TabaleViewCellHomeHeaderDelegate {
    func buttonPressed(sender: TableViewCellHomeHeader.ButtonType) {
        switch sender {
        case .gasto:
            let frameSelector = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            let parameters = DDSelectorParameters(isBlurred: true, bouncing: true)
            let mySelector = DDSelector(frame: frameSelector, parameters: parameters)
        
            let array = IORubroManager.rubros.compactMap({ $0.descripcion })
            mySelector.itemList = array
            mySelector.selectedItem = nil
//            view.addSubview(mySelector)

            UIApplication.shared.keyWindow?.addSubview(mySelector)
            
            mySelector.onSelectedItem = ({index -> Void in
                if index != nil {
                    self.performSegue(withIdentifier: "segue_gasto", sender: IORubroManager.rubros[index!])
                }
            })
            
            break
        case .ingreso:
            break
        }
    }
    
  
}
