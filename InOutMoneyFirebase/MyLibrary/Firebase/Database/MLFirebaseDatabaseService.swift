import Foundation
import Firebase

class MLFirebaseDatabaseService {
    
    static let instance = MLFirebaseDatabaseService()
    
    var observerRef: DatabaseReference!
    var observerRefHandle: DatabaseHandle!
    
    deinit {
        print("firebase observer removed at (\(observerRef.key))")
        observerRef.removeObserver(withHandle: observerRefHandle)
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
    
    
    static func retrieveDataWithFilter(path: String, keyName: String, value: Any, completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        let ref = Database.database().reference()
     
        let query = ref.child(path).queryOrdered(byChild: keyName).queryEqual(toValue: value)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if let datosDictionary = snapshot.value as? [String : Any] {
                completion(datosDictionary, nil)
            } else {
                completion(nil, nil)
            }
        }) {(error) in
            print(error.localizedDescription)
            completion(nil, error)
        }
    }
    
    static func retrieveData(path: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let ref = Database.database().reference()
        
        ref.child(path)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                 if let datosDictionary = snapshot.value as? [String : Any] {
                     completion(datosDictionary, nil)
                } else {
                    completion(nil, nil)
                }
                
            }) {(error) in
                print(error.localizedDescription)
                completion(nil, error)
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


