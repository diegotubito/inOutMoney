//
//  ViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 2/1/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
import Firebase

class IOHomeViewController: UIViewController {
    var service : IOLoginFirebaseService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        service = IOLoginFirebaseService()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user == nil {
                self.switchStoryboard()
            } else {
                print("you are logged in \(user?.uid)")
           //     self.userName = user?.displayName
           //     self.userUID = user?.uid
                
            }
        }
    }
    
    func switchStoryboard() {
        print("no hay usuario autenticado")
        //Go to the HomeViewController if the login is sucessful
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "StoryboardLogin", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "IOLoginUsuarioViewController") as? IOLoginUsuarioViewController
        vc?.viewModel = IOLoginUsuarioViewModel(withView: vc!, interactor: IOLoginFirebaseService(), user: "")
        self.present(vc!, animated: true, completion: nil)
        
        
    }

    @IBAction func goLoginPressed(_ sender: Any) {
        
        service.signOut(success: {
            print("sign out")
        }) {
            print(("error sign out"))
        }
        performSegue(withIdentifier: "segue_to_login", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? IOLoginUsuarioViewController {
            controller.viewModel = IOLoginUsuarioViewModel(withView: controller, interactor: IOLoginFirebaseService(), user: "")
        }
    }
    
}

