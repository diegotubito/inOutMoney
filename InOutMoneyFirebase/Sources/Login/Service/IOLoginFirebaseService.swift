//
//  IOLoginFirebaseService.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 3/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol IOLoginFirebaseServiceContract {
    func getUserByEmail(email: String, success: @escaping ([String]?) -> Void, fail: @escaping (String?) -> Void)
    
    func signInWithEmail(email: String, password: String, success: @escaping (User?) -> Void, fail: @escaping (String?) -> Void)
 
    func signOut(success: () -> Void, fail: () -> Void)
    
}

class IOLoginFirebaseService: IOLoginFirebaseServiceContract {
    func signOut(success: () -> Void, fail: () -> Void) {
        do {
            try Auth.auth().signOut()
            success()
        } catch {
            fail()
            return
        }
    }
    
    func signInWithEmail(email: String, password: String, success: @escaping (User?) -> Void, fail: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (usuario, error) in
            if error != nil {
                fail(error?.localizedDescription)
                return
            }
            
            if usuario != nil {
                success(usuario)
            }
        }
    }
    
  
    
    func getUserByEmail(email: String, success: @escaping ([String]?) -> Void, fail: @escaping (String?) -> Void) {
        Auth.auth().fetchProviders(forEmail: email) { (response, error) in
            if error != nil {
                fail(error?.localizedDescription)
                return
            }
            
            if response == nil {
                fail("Usuario Inexistente")
                return
            }
            
            success(response)
        }
    }
}
