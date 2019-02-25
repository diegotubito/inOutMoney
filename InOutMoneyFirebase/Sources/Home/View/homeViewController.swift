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
    
    
    var service : IOLoginFirebaseService!
    
    @IBOutlet var viewPrincipal: UIView!
    var authListener : AuthStateDidChangeListenerHandle!
    
    var viewModel : IOHomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                
                IOCuentaManager.loadCuentas(complete: {
                    print("cuentas cargadas")
                }, fail: { (message) in
                    print(message)
                })
            }
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

