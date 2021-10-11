//
//  Wallet.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation



struct WalletDataModel {
    
    var type: WalletType
    var backedup: Bool
    var transactions: [TransactionRecordDataModel]?
}

