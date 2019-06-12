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
    var cuentaCell : TableViewCellCuentas!
    
    var viewModel : HomeViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateRegistros), name: .updateRegistros, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateCuentas), name: .updateCuentas, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateRubros), name: .updateRubros, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = HomeViewModel(withView: self, databaseService: MLFirebaseDatabase(), authService: IOLoginFirebaseService())
        
        navigationItem.title = "Home"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        registerCells()
        loadCells()
        viewModel.listenAuth()
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction func nuewRubroPressed(_ sender: Any) {
        performSegue(withIdentifier: "segue_rubro_gasto", sender: nil)
    }
    
    func registerCells() {
        tableView.register(TableViewCellHomeHeader.nib, forCellReuseIdentifier: TableViewCellHomeHeader.identifier)
        tableView.register(TableViewCellCuentas.nib, forCellReuseIdentifier: TableViewCellCuentas.identifier)
    }
    

    @IBAction func logoutPressed(_ sender: Any) {
        
        viewModel.signOut()
        
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
        cells.removeAll()
        
        header = tableView.dequeueReusableCell(withIdentifier: TableViewCellHomeHeader.identifier) as? TableViewCellHomeHeader
        
         header.delegate = self
        cells.append(header)
        
        cuentaCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellCuentas.identifier) as? TableViewCellCuentas
        cells.append(cuentaCell)
        
        tableView.reloadData()
    }
    
    func toast(message: String) {
        Toast.show(message: message, controller: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super .prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? IOLoginUsuarioViewController {
            controller.viewModel = IOLoginUsuarioViewModel(withView: controller, interactor: IOLoginFirebaseService(), user: "")
        }
        
        if let controller = segue.destination as? IOAltaGastoViewController {
            if let object = sender as? IOProjectModel.Rubro, let cuentas = viewModel.model.cuentas {
                controller.viewModel = IORubrosGastosAltaViewModel(withView: controller, rubroSeleccionado: object, cuentas: cuentas)
            }
        
        }
        
        if let controller = segue.destination as? IOAltaIngresoViewController {
             if let object = sender as? IOProjectModel.Rubro, let cuentas = viewModel.model.cuentas {
                controller.viewModel = IOAltaIngresoViewModel(withView: controller, rubroSeleccionado: object, cuentas: cuentas)
            }
            
        }
        
        if let controller = segue.destination as? IOAltaRubroViewController {
             controller.viewModel = IOAltaRubroViewModel(withView: controller)
        }
    
    }
}

//conform protocol HomeViewModelProtocol
extension HomeViewController: HomeViewProtocol{

    func disabledButtons() {
        header.disableActions()
    }
    
    func enableButtons() {
        header.enableActions()
    }
    
    func reloadList() {
        self.viewModel.cargarRubros()
        self.viewModel.cargarCuentas()
        self.viewModel.cargarRegistrosMesActual()
        self.viewModel.cargarRegistrosMesAnterior()
        self.viewModel.cargarRegistrosMesAnteriorAnterior()
    }
    
    func showError(_ message: String) {
        Toast.show(message: message, controller: self)
    }
    
    func showSuccess() {
        
    }
    
    func updateCuentas() {
        if viewModel.model.cuentas?.count == 2 {
            let efectivo = viewModel.model.cuentas?[1].saldo
            let banco = viewModel.model.cuentas?[0].saldo
            cuentaCell.totalEfectivoLabel.text = efectivo?.formatoMoneda(decimales: 2, simbolo: "$")
            
            cuentaCell.totalBancoLabel.text = banco?.formatoMoneda(decimales: 2, simbolo: "$")
        }
        
    }
    
    func updateRegistrosMesActual(registros: [IOProjectModel.Registro]) {
        let totalGasto = viewModel.getTotalGasto(registros: registros)
        header.totalGastoMes.text = totalGasto.formatoMoneda(decimales: 2, simbolo: "$")
        
        let totalIngreso = viewModel.getTotalIngreso(registros: registros)
        header.totalIngresoMes.text = totalIngreso.formatoMoneda(decimales: 2, simbolo: "$")
        
        
    }
    
    func updateRegistrosMesAnterior(registros: [IOProjectModel.Registro]) {
        let totalGasto = viewModel.getTotalGasto(registros: registros)
        header.totalGastoMesAnterior.text = totalGasto.formatoMoneda(decimales: 2, simbolo: "$")
        
        let totalIngreso = viewModel.getTotalIngreso(registros: registros)
        header.totalIngresoMesAnterior.text = totalIngreso.formatoMoneda(decimales: 2, simbolo: "$")
        
        
    }
    
    func updateRegistrosMesAnteriorAnterior(registros: [IOProjectModel.Registro]) {
        let totalGasto = viewModel.getTotalGasto(registros: registros)
        header.totalGastoMesAnteriorAnterior.text = totalGasto.formatoMoneda(decimales: 2, simbolo: "$")
        
        let totalIngreso = viewModel.getTotalIngreso(registros: registros)
        header.totalIngresoMesAnteriorAnterior.text = totalIngreso.formatoMoneda(decimales: 2, simbolo: "$")
        
        
    }
    
    func stopAnimatingActivityMesActual() {
        header.activityIndicatorGastoMes.stopAnimating()
        header.activityIndicatorIngresoMes.stopAnimating()
    }
    
    func startAnimatingActivityMesActual() {
        header.activityIndicatorGastoMes.startAnimating()
        header.activityIndicatorIngresoMes.startAnimating()
    }
    func stopAnimatingActivityMesAnterior() {
        header.activityIndicatorGastoMesAnterior.stopAnimating()
        header.activityIndicatorIngresoMesAnterior.stopAnimating()
    }
    
    func startAnimatingActivityMesAnterior() {
        header.activityIndicatorGastoMesAnterior.startAnimating()
        header.activityIndicatorIngresoMesAnterior.startAnimating()
    }
    func stopAnimatingActivityMesAnteriorAnterior() {
        header.activityIndicatorGastoMesAnteriorAnterior.stopAnimating()
        header.activityIndicatorIngresoMesAnteriorAnterior.stopAnimating()
    }
    
    func startAnimatingActivityMesAnteriorAnterior() {
        header.activityIndicatorGastoMesAnteriorAnterior.startAnimating()
        header.activityIndicatorIngresoMesAnteriorAnterior.startAnimating()
    }

}

// TABLE VIEW DATA SOURCE
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
}

//Tableview Delegates
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UIScreen.main.bounds.height*0.30
            
        } else {
            return UIScreen.main.bounds.height*0.2
        }
    }
}

// delegates
extension HomeViewController: TabaleViewCellHomeHeaderDelegate {
    func buttonPressed(sender: TableViewCellHomeHeader.ButtonType) {
        switch sender {
        case .gasto:
            let frameSelector = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            let parameters = DDSelectorParameters(isBlurred: true, bouncing: true)
            let mySelector = DDSelector(frame: frameSelector, parameters: parameters)
        
            //solo me quedo con los rubros de gasto
            let fileredArray = viewModel.model.rubros?.filter({$0.type == ProjectConstants.rubros.gastoKey})
            
            //creamos un array de String
            let array = fileredArray?.compactMap({ $0.descripcion })
            
            //le pasamos el array al custom view
            mySelector.itemList = array ?? []
            
            mySelector.selectedItem = nil
//            view.addSubview(mySelector)

            UIApplication.shared.keyWindow?.addSubview(mySelector)
            
            mySelector.onSelectedItem = ({index -> Void in
                if index != nil {
                    self.performSegue(withIdentifier: "segue_gasto", sender: self.viewModel.model.rubros?[index!])
                }
            })
            
            break
        case .ingreso:
            let frameSelector = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            let parameters = DDSelectorParameters(isBlurred: true, bouncing: true)
            let mySelector = DDSelector(frame: frameSelector, parameters: parameters)
            
            //solo me quedo con los rubros de gasto
            let fileredArray = viewModel.model.rubros?.filter({$0.type == ProjectConstants.rubros.ingresoKey})
            
            //creamos un array de String
            let array = fileredArray?.compactMap({ $0.descripcion })
            
            //le pasamos el array al custom view
            mySelector.itemList = array ?? []
            
            mySelector.selectedItem = nil
            //            view.addSubview(mySelector)
            
            UIApplication.shared.keyWindow?.addSubview(mySelector)
            
            mySelector.onSelectedItem = ({index -> Void in
                if index != nil {
                    self.performSegue(withIdentifier: "segue_ingreso", sender: self.viewModel.model.rubros?[index!])
                }
            })
            
            break
            
        }
    }
    
  
}

//notifications
extension HomeViewController {
    @objc func handleUpdateRegistros() {
        print("notification REGISTROS update")
        viewModel.cargarRegistrosMesActual()
        viewModel.cargarRegistrosMesAnterior()
        viewModel.cargarRegistrosMesAnteriorAnterior()
    }
    
    @objc func handleUpdateCuentas() {
        print("notification CUENTAS update")
        viewModel.cargarCuentas()
    }
    
    @objc func handleUpdateRubros() {
        print("notification RUBROS update")
        viewModel.cargarRubros()
    }
    
}
