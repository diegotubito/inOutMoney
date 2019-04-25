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
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    @IBOutlet var tableView: UITableView!
    var service : IOLoginFirebaseService!
    var cells = [UITableViewCell]()
    var cellEntradaSalida : IOTableViewCellEntradaSalida!
    
    var authListener : AuthStateDidChangeListenerHandle!
    
    var viewModel : IOHomeViewModel!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
       
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        
        
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
    
    @IBAction func selector(_ sender: Any) {
        let mySelector = DDSelector(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        let list = ["Todos los rubros seleccionados", "Quesos", "Lacteos", "Verduras", "Carnes", "Pescado", "Legumbres", "Mantecas", "Ravioles", "Guisos", "Tapioca", "Mariscos", "Asados"]
        mySelector.optionList = list
        UIApplication.shared.keyWindow?.addSubview(mySelector)
        mySelector.itemAlreadySelected = 5
        mySelector.onSelectedItem = { (index) -> Void in
            print("Item seleccionado: \(String(describing: index))")
        }
    }
    
   
    @IBAction func home2PRessed(_ sender: Any) {
        performSegue(withIdentifier: "segue_to_home2", sender: nil)
    }
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        start()
    }
    
    func start() {
        
        IOCuentaManager.loadCuentasFromFirebase(success: {
            print("tengo las cuentas")
           
            IORubroManager.loadRubrosFromFirebase(success: {
                print("tengo los rubros")
                
                IORegistroManager.loadRegistrosFromFirebase(mes: 3, año: 2019, success: {
                    print("tengo los registros")
                    let total = IORegistroManager.getTotalRegistros()
                    print("el total de gastos del mes de marzo es : \(total)")
                    
                    self.viewModel.crearItems()
                    self.refreshControl.endRefreshing()
                }, fail: { (errorString) in
                    self.refreshControl.endRefreshing()
                    
                    self.toast(message: "Error al cargar registros")
                    print(errorString)
                })
                
            }) { (errorString) in
                self.refreshControl.endRefreshing()
                self.toast(message: "Error al cargar rubros")
                
                print(errorString)
            }
            
            
        }, fail: { (message) in
            self.refreshControl.endRefreshing()
            self.toast(message: "Error al cargar cuentas")
            
            print(message)
        })
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserID != nil {
            start()
        }
    }
    func reloadList() {
        tableView.reloadData()
    }

    func registerCells() {
        
        tableView.register(IOTableViewCellEntradaSalida.nib, forCellReuseIdentifier: IOTableViewCellEntradaSalida.identifier)
        tableView.register(IOTableViewCellHomeRubroGasto.nib, forCellReuseIdentifier: IOTableViewCellHomeRubroGasto.identifier)
        tableView.register(IOTableViewCellCuentaInfo.nib, forCellReuseIdentifier: IOTableViewCellCuentaInfo.identifier)
        tableView.register(IOTableViewCellOwnHeaderHome.nib, forCellReuseIdentifier: IOTableViewCellOwnHeaderHome.identifier)
    }
    

    func switchStoryboard() {
        //Go to the HomeViewController if the login is sucessful
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "StoryboardLogin", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "IOLoginUsuarioViewController") as? IOLoginUsuarioViewController
        vc?.viewModel = IOLoginUsuarioViewModel(withView: vc!, interactor: IOLoginFirebaseService(), user: "")
        self.present(vc!, animated: true, completion: nil)
        
        
    }

      @IBAction func log_out_pressed(_ sender: Any) {
        
        service.signOut(success: {
            print("sign out")
        }) {
            toast(message: "Error al cerrar sesión.")
        }
     }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super .prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? IOLoginUsuarioViewController {
            controller.viewModel = IOLoginUsuarioViewModel(withView: controller, interactor: IOLoginFirebaseService(), user: "")
        }
        
        if let controller = segue.destination as? IORubrosProfileViewController {
            controller.viewModel = IORubrosProfileViewModel(withView: controller, rubroSeleccionado: viewModel.model.rubroSeleccionado!, fechaSeleccionada: viewModel.model.periodoSeleccionado)
        }
        
        if let controller = segue.destination as? IOAltaRubroViewController {
            controller.viewModel = IOAltaRubroViewModel(withView: controller)
        }
    }
    
    func toast(message: String) {
        Toast.show(message: message, controller: self)
    }
    
    func goToProfileRubro() {
        performSegue(withIdentifier: "segue_to_rubro_profile", sender: nil)
    }
    
}

extension IOHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            viewModel.setRubroSeleccionado(index: indexPath.row)
            
        }
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
            break
        case .rubroGasto:
             if let item = item as? HomeProfileViewModelRubrosItem, let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellHomeRubroGasto.identifier, for: indexPath) as? IOTableViewCellHomeRubroGasto {
                let friend = item.rubros[indexPath.row]
                cell.item = friend
                return cell
            }
            break
        case .cuentas:
            if let item = item as? HomeProfileViewModelCuentasItem, let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellCuentaInfo.identifier, for: indexPath) as? IOTableViewCellCuentaInfo {
                let cuenta = item.cuentas[indexPath.row]
                cell.item = cuenta
                return cell
            }
            break
        case .rubroIngreso:
            break
        case .ownHeader:
            if let cell = tableView.dequeueReusableCell(withIdentifier: IOTableViewCellOwnHeaderHome.identifier, for: indexPath) as? IOTableViewCellOwnHeaderHome {
                cell.item = item
                cell.delegate = self
                return cell
            }
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.model.items[section].sectionTitle
    }
}


extension IOHomeViewController : IOTableViewCellOwnHeaderHomeDelegate {
    func didTappedDelegate(keyName: String) {
        print(keyName)
        viewModel.crearItems()
        
        if keyName == "rubroGastoHeader" {
            alertActionsRubroGastos()
        } else if keyName == "cuentaHeader" {
            alertActionsCuentas()
        }
    }
    
    
    func alertActionsRubroGastos() {
        let alert = UIAlertController(title: "Rubros Gastos", message: "Selecciona una opción", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Nuevo Rubro", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.performSegue(withIdentifier: "segue_to_alta_rubro", sender: nil)
        }))
        
       
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func alertActionsCuentas() {
        let alert = UIAlertController(title: "Cuentas", message: "Selecciona una opción", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Nueva Cuenta", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
}