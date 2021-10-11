//
//  WalletDataModelManager.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation

class WalletDataModelManager {

    static let shared = WalletDataModelManager()
    
    var walletData = [WalletDataModel]()
    
    private init() {
        
        self.walletData.append(WalletDataModel(type:.xe, backedup: false, transactions: [
            TransactionRecordDataModel(type:.receive, status:.pending, date:"test", amount:"12.000000"),
            TransactionRecordDataModel(type:.send, status:.confirmed, date:"test", amount:"9.001000"),
            TransactionRecordDataModel(type:.exchange, status:.confirmed, date:"test", amount:"4.120000")
                                               ]))
        self.walletData.append(WalletDataModel(type:.edge, backedup: false, transactions: [
            TransactionRecordDataModel(type:.receive, status:.confirmed, date:"test", amount:"5.110000")
                                               ]))
        self.walletData.append(WalletDataModel(type:.xe, backedup: false, transactions: [
            TransactionRecordDataModel(type:.receive, status:.pending, date:"test", amount:"3.200000"),
            TransactionRecordDataModel(type:.receive, status:.confirmed, date:"test", amount:"1.000000")
                                               ]))
        self.walletData.append(WalletDataModel(type:.ethereum, backedup: true, transactions: [
                                               ]))
    }
    
    public func getWalletData() -> [WalletDataModel] {
        
        return self.walletData
    }
}
