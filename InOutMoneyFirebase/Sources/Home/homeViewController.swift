//
//  ViewController.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 2/1/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOHomeViewController: UIViewController {
    var service : IOLoginFirebaseService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        service = IOLoginFirebaseService()
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

