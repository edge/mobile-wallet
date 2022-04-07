//
//  Notification+Ext.swift
//  xe_wallet
//
//  Created by Paul Davis on 17/11/2021.
//

import Foundation

extension Notification.Name {
    
    static let didReceiveData = Notification.Name("didReceiveData")
    static let forceMainPageRefresh = Notification.Name("forceMainPageRefresh")
    static let forceRefreshOnChange = Notification.Name("forceRefreshOnChange")
    static let setWalletCardAmount = Notification.Name("setWalletCardAmount")
    static let exchangeSetDefaultCard = Notification.Name("exchangeSetDefaultCard")
    static let saveAllWalletData = Notification.Name("saveAllWalletData")
    static let appEnteredForeground = Notification.Name("appEnteredForeground")
    static let learnForceUpdate = Notification.Name("learnForceUpdate")
    static let earnForceUpdate = Notification.Name("earnForceUpdate")
}
