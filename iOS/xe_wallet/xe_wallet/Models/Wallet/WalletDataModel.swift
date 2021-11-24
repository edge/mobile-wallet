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
    var created: Double
    var backedup: Double
    var status: WalletStatusDataModel?
    var transactions: TransactionsDataModel?
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case address
        case created
        case backedup
        case status
        case transactions
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(WalletType.self, forKey: .type)
        self.address = try container.decode(String.self, forKey: .address)
        self.created = try container.decode(Double.self, forKey: .created)
        self.backedup = try container.decode(Double.self, forKey: .backedup)
        self.status = try container.decode(WalletStatusDataModel.self, forKey: .status)
        self.transactions = nil
        
        self.downloadWalletsData()
    }
    
    public init(type: WalletType, address: String) {
        
        self.type = type
        self.address = address
        self.created = Date().timeIntervalSince1970
        self.backedup = Date().timeIntervalSince1970
        self.status = WalletStatusDataModel(address: address, balance: 0, nonce: 0)
        self.transactions = nil
        
        self.downloadWalletsData()
    }
    
// TODO use protocols for wallets with same functionality
    
    func downloadWalletsData() {
                
        switch self.type {
            
        case .xe:
            let walletController = XEWallet()
            
            walletController.downloadStatus(address: self.address, completion:{ status in
            
                self.status = status
                walletController.downloadTransactions(address: self.address, completion:{ transactions in
                
                    self.transactions = transactions
                    
                    NotificationCenter.default.post(name: .didReceiveData, object: nil)
                })
            })
            break
            
        case .ethereum:
            let walletController = EtherWallet()
            walletController.downloadStatus(address: self.address, completion:{ status in
            
                self.status = status
                walletController.downloadTransactions(address: self.address, completion:{ transactions in
                
                    self.transactions = transactions
                    NotificationCenter.default.post(name: .didReceiveData, object: nil)
                })
            })
            break
            
        case .edge:
            break
        }
    }
}
