//
//  IORemoteConfig.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit
import Firebase

class IORemoteConfigService {
    
    static var instance = IORemoteConfigService()
    
    func defaultValuesRemoteConfig() {
        let values = ["seasson_login_background" : "degrade" as NSObject]
        
        RemoteConfig.remoteConfig().setDefaults(values)
    }
    
    func fetchRemoteConfig(success: @escaping (RemoteConfig) -> Void, fail: @escaping (Error?) -> Void) {
        //sacar esto cuando se lance a produccion
        let debug = RemoteConfigSettings(developerModeEnabled: true)
        RemoteConfig.remoteConfig().configSettings = debug!
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { (status, error) in
            guard error == nil else {
                print("oh no an error ocurred")
                fail(error)
                return
            }
            
            print("retrieved values from the cloud")
            RemoteConfig.remoteConfig().activateFetched()
            success(RemoteConfig.remoteConfig())
        }
        
    }
    
  
    
}
