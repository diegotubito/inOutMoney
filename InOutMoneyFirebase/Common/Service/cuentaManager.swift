//
//  cuentaManager.swift
//  ReleaseVersion
//
//  Created by David Diego Gomez on 30/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation

class IOAccountManager {
    static let instance = IOAccountManager()
    
    enum AccountError: Error {
        case empty
        case standard
    }
    
    func retrieveAccounts() throws -> [String : Any]? {
        var finalResponse : [String: Any]?
        var error : Error?
        let semasphore = DispatchSemaphore(value: 1)
        
        MLFirebaseDatabaseService.retrieveData(path: UserID! + "/cuentas") { (response, err) in
           
    
            error = err
            finalResponse = response
            semasphore.signal()
            
        }
        
        _ = semasphore.wait(timeout: .distantFuture)

        if error != nil {
            throw AccountError.standard
        }
        
        if finalResponse == nil {
            throw AccountError.empty
        }
        
        return finalResponse
    }
    
    
    
}
