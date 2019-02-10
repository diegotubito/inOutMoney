//
//  alamofireExtension.swift
//  coreGymMobile
//
//  Created by David Diego Gomez on 12/8/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//
import UIKit
import Alamofire


class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
