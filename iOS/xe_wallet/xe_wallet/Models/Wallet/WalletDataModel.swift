//
//  Wallet.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import UIKit
import Alamofire

class WalletDataModel: Codable {

    var type: WalletType
    var address: String
    var status: WalletStatusDataModel?
    var transactions: TransactionsDataModel?
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case address
        case status
        case transactions
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(WalletType.self, forKey: .type)
        self.address = try container.decode(String.self, forKey: .address)
        self.status = try container.decode(WalletStatusDataModel.self, forKey: .status)
        self.transactions = nil
        
        self.downloadWalletsData()
    }
    
    public init(type: WalletType, address: String) {
        
        self.type = type
        self.address = address
        self.status = WalletStatusDataModel(address: address)
        self.transactions = nil
        
        self.downloadWalletsData()
    }
    
    func downloadWalletsData() {
        
        switch self.type {
            
        case .xe:
            let xeWallet = XEWallet()
            xeWallet.downloadStatus(address: self.address, completion:{ status in
            
                self.status = status
                xeWallet.downloadTransactions(address: self.address, completion:{ transactions in
                
                    self.transactions = transactions
                    NotificationCenter.default.post(name: .didReceiveData, object: nil)
                })
            })
            break
            
        case .ethereum:
            break
            
        case .edge:
            break
        }
    }
}
