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
    func getUserByEmail(email: String, success: @escaping ([String]?) -> Void, fail: @escaping (Error?) -> Void)
    
    func signInWithEmail(email: String, password: String, success: @escaping (User?) -> Void, fail: @escaping (Error?) -> Void)
 
    func signOut(success: () -> Void, fail: () -> Void)
    
    func registerNewUser(email: String, password: String, success: @escaping (User) -> Void, fail: @escaping (Error) -> Void) 

    
}

class IOLoginFirebaseService: IOLoginFirebaseServiceContract {
    
    func registerNewUser(email: String, password: String, success: @escaping (User) -> Void, fail: @escaping (Error) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                fail(error!)
                return
            }
        
            success(user!)
            
        }
    }
    
    func signOut(success: () -> Void, fail: () -> Void) {
        do {
            try Auth.auth().signOut()
            success()
        } catch {
            fail()
            return
        }
    }
    
    func signInWithEmail(email: String, password: String, success: @escaping (User?) -> Void, fail: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (usuario, error) in
            if error != nil {
                fail(error)
                return
            }
            
            if usuario != nil {
                success(usuario)
            }
        }
    }
    
  
    
    func getUserByEmail(email: String, success: @escaping ([String]?) -> Void, fail: @escaping (Error?) -> Void) {
        Auth.auth().fetchProviders(forEmail: email) { (response, error) in
            if error != nil {
                fail(error)
                return
            }
            
            if response == nil {
                fail(nil)
                return
            }
            
            success(response)
        }
    }
}
