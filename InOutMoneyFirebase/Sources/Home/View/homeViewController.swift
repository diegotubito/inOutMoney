//
//  ViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 2/1/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
import Firebase

var UserID : String?

class IOHomeViewController: UIViewController, IOHomeViewContract {
    
    @IBOutlet var tableView: UITableView!
    var service : IOLoginFirebaseService!
    var cells = [UITableViewCell]()
    var cellEntradaSalida : IOTableViewCellEntradaSalida!
    
    var authListener : AuthStateDidChangeListenerHandle!
    
    var viewModel : IOHomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        registerCells()
        

        viewModel = IOHomeViewModel(withView: self)
        
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
                self.start()
            }
        }
     
        
    }
    
    
    func start() {
        
        IOCuentaManager.loadCuentasFromFirebase(success: {
            print("tengo las cuentas")
        }, fail: { (message) in
            print(message)
        })
        
        IORubroManager.loadRubrosFromFirebase(success: {
            print("tengo los rubros")
            self.tableView.reloadData()
            IORegistroManager.loadRegistrosFromFirebase(mes: 3, año: 2019, success: {
                print("tengo los registros")
                let total = IORegistroManager.getTotalRegistros()
                print("el total de gastos del mes de marzo es : \(total)")
               
                self.viewModel.crearItems()
            }, fail: { (errorString) in
                print(errorString)
            })
            
        }) { (errorString) in
            print(errorString)
        }
        
    }
    
    func reloadList() {
        tableView.reloadData()
    }

    func registerCells() {
        
        tableView.register(IOTableViewCellEntradaSalida.nib, forCellReuseIdentifier: IOTableViewCellEntradaSalida.identifier)
        tableView.register(IOTableViewCellHomeRubroGasto.nib, forCellReuseIdentifier: IOTableViewCellHomeRubroGasto.identifier)
    }
    

    func switchStoryboard() {
        //Go to the HomeViewController if the login is sucessful
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "StoryboardLogin", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "IOLoginUsuarioViewController") as? IOLoginUsuarioViewController
        vc?.viewModel = IOLoginUsuarioViewModel(withView: vc!, interactor: IOLoginFirebaseService(), user: "")
        self.present(vc!, animated: true, completion: nil)
        
        
    }

    @IBAction func gastosPresionado(_ sender: Any) {
        performSegue(withIdentifier: "segue_to_gastos", sender: nil)
    }
    @IBAction func log_out_pressed(_ sender: Any) {
        
        service.signOut(success: {
            print("sign out")
        }) {
            toast(message: "Error al cerrar sesión.")
        }
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? IOLoginUsuarioViewController {
            controller.viewModel = IOLoginUsuarioViewModel(withView: controller, interactor: IOLoginFirebaseService(), user: "")
        }
        
        if let controller = segue.destination as? IORubrosListadoViewController {
            
                controller.viewModel = IORubrosListadoViewModel(withView: controller)
        }
        
    }
    
    func toast(message: String) {
        Toast.show(message: message, controller: self)
    }
    
}



extension IOHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.model.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.model.items[indexPath.section]
        switch item.type {
        case .entradaSalida:
            if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellEntradaSalida.identifier, for: indexPath) as? IOTableViewCellEntradaSalida {
                cell.item = item
                return cell
            }
        case .rubroGasto:
             if let item = item as? HomeProfileViewModelRubrosItem, let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellHomeRubroGasto.identifier, for: indexPath) as? IOTableViewCellHomeRubroGasto {
                let friend = item.rubros[indexPath.row]
                cell.item = friend
                return cell
            }
       
        case .cuentas:
            if let item = item as? HomeProfileViewModelCuentasItem, let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellCuentaInfo.identifier, for: indexPath) as? IOTableViewCellCuentaInfo {
                let cuenta = item.cuentas[indexPath.row]
                cell.item = cuenta
            }
            break
        case .rubroIngreso:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.model.items[section].sectionTitle
    }
}
