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
    
    static func setData2() {
        let ref = Database.database().reference()
        
        ref.childByAutoId()
        
    }

    
    static func setData(path: String, diccionario: [String: Any], success: @escaping (DatabaseReference) -> Void, fail: @escaping (Error?) -> Void) {
        
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

}


