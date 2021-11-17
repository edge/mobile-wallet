//
//  AppDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation

struct AppDataModel {
    
    var pinCode: String = ""
    var testMode = true
    
    var XE_MainNetStatusUrl = "https://api.xe.network/wallet/"
    var XE_TestNetStatusUrl = "https://xe1.test.network/wallet/"
    
    var XE_MainNetTransactionUrl = "https://index.xe.network/transactions/"
    var XE_TestNetTransactionUrl = "https://index.test.network/transactions/"
    
    var XE_networkMainNetTitle = "Edge (XE) Mainnet"
    var XE_networkTestNetTitle = "Edge (XE) Testnet"
}
