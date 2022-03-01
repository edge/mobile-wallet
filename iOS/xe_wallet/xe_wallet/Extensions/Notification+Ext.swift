//
//  Notification+Ext.swift
//  xe_wallet
//
//  Created by Paul Davis on 17/11/2021.
//

import Foundation

extension Notification.Name {
    
    static let didReceiveData = Notification.Name("didReceiveData")
    static let setWalletCardAmount = Notification.Name("setWalletCardAmount")
    static let exchangeSetDefaultCard = Notification.Name("exchangeSetDefaultCard")
}
