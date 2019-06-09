//
//  FirebaseGeneric.swift
//  ReleaseVersion
//
//  Created by David Diego Gomez on 8/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import Firebase

class Memeber {
    var childID : String?
}

class MLFirebaseDatabase {
    static let instance = MLFirebaseDatabase()
    
    
    var observerRef: DatabaseReference!
    var observerRefHandle: DatabaseHandle!
    
    deinit {
        print("firebase observer removed at (\(observerRef.key))")
        observerRef.removeObserver(withHandle: observerRefHandle)
    }
    
    
    func jsonArray(json: [String: Any]) -> [[String: Any]] {
        var result = [[String : Any]]()
        
        for (key, value) in json {
            if let aux = value as? [String : Any] {
                var aux2 = aux
                aux2["key"] = key
                result.append(aux2)
            }
        }
        
        return result
    }
    
    
    func fetchWithQuery<T:Decodable>(path: String, keyName: String, value: Any, completion: @escaping (T?) -> Void, err: @escaping (Error?) -> Void) {
        
        let ref = Database.database().reference()
        
        let query = ref.child(path).queryOrdered(byChild: keyName).queryEqual(toValue: value)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            
           
            guard let json = snapshot.value as? [String : Any] else {
                completion(nil)
                return
            }
            
            do  {
                //convert json into jsonArray, with deleted keys.
                let jsonArray = self.jsonArray(json: json)
                
                //convert jsonArray into Data
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                
                //Parse
                let obj = try JSONDecoder().decode(T.self, from: data)
                
                completion(obj)
            } catch {
                err(error)
            }
        }) {(error) in
            
            err(error)
        }
    }
    
    func fetch<T:Decodable>(path: String, completion: @escaping (T?) -> Void, err: @escaping (Error?) -> Void) {
        
        let ref = Database.database().reference()
        
        ref.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let json = snapshot.value as? [String : Any] else {
                completion(nil)
                return
            }
            
            do  {
                //convert json into jsonArray, with deleted keys.
                let jsonArray = self.jsonArray(json: json)
                
                //convert jsonArray into Data
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                
                //Parse
                let obj = try JSONDecoder().decode(T.self, from: data)
                
                completion(obj)
            } catch {
                err(error)
            }
        }) {(error) in
            
            err(error)
        }
    }

    
    func fetchDataTask<T : Decodable>(fullPath: String, completion: @escaping (T?) -> Void, errorMessage: @escaping (String) -> Void) {
        let task = URLSession.shared
        
        let url = URL(string: fullPath)!
        
        task.dataTask(with: url) { (data, response, error) in
            //error handling
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                let message = String(httpStatus.statusCode) + ", " + String(describing: response)
                errorMessage(message)
                return
            }
            //error handling
            guard error == nil else {
                let message = error?.localizedDescription ?? "unknown error"
                errorMessage(message)
                return
            }
            //empty data
            guard let data = data else {
                completion(nil)
                return
            }
            
            //data handler
            do {
                //converto Data into [String : Any]
                let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                
                //convert JSON into [[String : Any]]
                let jsonArray = self.jsonArray(json: jsonSerialized)
                
                //Convert jsonArray into Data so that i can serialize it
                let dataObject = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                
                //finally Parse into Class
                let obj = try JSONDecoder().decode(T.self, from: dataObject)
                
                //return result
                completion(obj)
            } catch {
                errorMessage(error.localizedDescription)
                return
            }
            }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    static func childIDInSecondsSince(date: Date) -> String {
        let keyInt = Int(date.getMilisecondsFromDateUntilNow())
        let keyRoundedString = String(keyInt)
        
        return keyRoundedString
    }
    
    static func setDataWithAutoId(path: String, diccionario: [String: Any], success: @escaping (DatabaseReference) -> Void, fail: @escaping (Error?) -> Void) {
        
        let ref = Database.database().reference()
        
        // Guardo los datos del nuevo socio en la Firebase
        ref.child(path).childByAutoId().setValue(diccionario) { (error, ref) -> Void in
            if error == nil {
                success(ref)
            }else {
                fail(error)
            }
        }
        
        
    }
    
    static func setData(path: String, diccionario: [String: Any], success: @escaping (DatabaseReference) -> Void, fail: @escaping (Error?) -> Void) {
        
        let ref = Database.database().reference()
        
        // Guardo los datos del nuevo socio en la Firebase
        ref.child(path).setValue(diccionario) { (error, ref) -> Void in
            if error == nil {
                success(ref)
            }else {
                fail(error)
            }
        }
        
        
    }
    
    static func update(path: String, diccionario: [String: Any], success: @escaping (DatabaseReference) -> Void, fail: @escaping (Error?) -> Void) {
        
        let ref = Database.database().reference()
        
        // Guardo los datos del nuevo socio en la Firebase
        ref.child(path).updateChildValues(diccionario) { (error, ref) in
            if error == nil {
                success(ref)
                return
            }
            
            fail(error)
            
            
        }
        
        
        
    }
    
    static func update(path: String, diccionario: [String: Any]) {
        
        let ref = Database.database().reference()
        
        // Guardo los datos del nuevo socio en la Firebase
        ref.child(path).updateChildValues(diccionario) { (error, ref) in
        }
        
        
        
    }
    
    static func delete(path: String,  success: @escaping (Bool, Error?) -> Void) {
        let ref = Database.database().reference()
        
        ref.child(path).removeValue() { (error, ref) -> Void in
            if error == nil {
                success(true, nil)
            } else {
                success(false, error)
            }
        }
        
    }
    
    static func delete(path: String) {
        let ref = Database.database().reference()
        
        ref.child(path).removeValue() { (error, ref) -> Void in
            
        }
        
    }
    
   
    static func isChildThere(path: String, child: String, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        
        ref.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(child) {
                completion(true)
            } else {
                completion(false)
            }
        })
        
    }
    
    func addObserver(atPath: String, completion: @escaping ([String: Any]?) -> Void) {
        if observerRef != nil {return}
        
        let ref = Database.database().reference()
        
        observerRef = ref.child(atPath)
        
        observerRefHandle = observerRef.observe(.value, with: { (snapshot) in
            if let datosDictionary = snapshot.value as? [String : Any] {
                completion(datosDictionary)
                
            } else {
                completion(nil)
            }
            
        })
        
    }
    
    static func setTransaction(path: String, keyName: String, incremento: Double, success: @escaping () -> Void, fail: @escaping (Error) -> Void) {
        let ref = Database.database().reference()
        
        ref.child(path).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject] {
                var starCount = post[keyName] as? Double ?? 0
                starCount += incremento
                post[keyName] = starCount as AnyObject
                // Set value and report transaction success
                currentData.value = post
                
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
                fail(error)
            }
            if committed {
                success()
            }
        }
        
    }
    
    static func setTransaction(path: String, keyName: String, incremento: Double) {
        let ref = Database.database().reference()
        
        ref.child(path).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject] {
                var starCount = post[keyName] as? Double ?? 0
                starCount += incremento
                post[keyName] = starCount as AnyObject
                // Set value and report transaction success
                currentData.value = post
                
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
                
            }
            if committed {
                
            }
        }
        
    }
}
