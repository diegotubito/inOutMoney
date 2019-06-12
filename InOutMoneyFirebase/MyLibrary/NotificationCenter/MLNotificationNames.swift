//
//  MLNotificationNames.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 9/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//
import UIKit


extension Notification.Name {
    static let rcDidChanged = Notification.Name("rcDidChanged")
    static let progressNotification = Notification.Name("progressNotification")
    
    static let updateRegistros = Notification.Name("updateRegistros")
    static let updateCuentas = Notification.Name("updateCuentas")
    static let updateRubros = Notification.Name("updateRubros")
    static let coredataNotification = Notification.Name("coredataNotification")
    static let didReceiveUpdate = Notification.Name("didReceiveUpdate")
    static let didReceiveData = Notification.Name("didReceiveData")
    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}
