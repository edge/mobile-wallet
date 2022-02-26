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
    var wallet: Wallet?
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case address
        case created
        case backedup
        case status
        case transactions
        case wallet
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(WalletType.self, forKey: .type)
        self.address = try container.decode(String.self, forKey: .address)
        self.created = try container.decode(Double.self, forKey: .created)
        self.backedup = try container.decode(Double.self, forKey: .backedup)
        self.status = try container.decode(WalletStatusDataModel.self, forKey: .status)
        self.transactions = nil
        self.wallet = try container.decodeIfPresent(Wallet.self, forKey: .wallet)
        
        self.downloadWalletStatus()
        self.downloadWalletTransactions()
    }
    
    public init(type: WalletType, wallet: AddressKeyPairModel) {
        
        self.type = type
        self.address = wallet.address
        self.created = Date().timeIntervalSince1970
        self.backedup = Date().timeIntervalSince1970

        self.status = WalletStatusDataModel(address: wallet.address, balance: 0, nonce: 0)
        self.transactions = nil
        
        self.wallet = wallet.wallet
        
        self.downloadWalletStatus()
        self.downloadWalletTransactions()
        
    }
    
    func downloadWalletStatus() {
                
        switch self.type {
            
        case .xe:
            XEWallet().downloadStatus(address: self.address, completion: { status in
            
                if let stat = status {
                
                    if (self.status != nil) {
                        
                        self.status = nil
                    }
                    self.status = WalletStatusDataModel(from: stat)
                }
            })
            break
            
        case .ethereum:
            EtherWallet().downloadStatus(address: self.address, completion: { status in
                
                if let stat = status {
                
                    if (self.status != nil) {
                        
                        self.status = nil
                    }
                    self.status = WalletStatusDataModel(from: stat)
                }
            })
            break
            
        case .edge:
            break
            
        case .usdc:
            break
        }
    }
    
    func downloadWalletTransactions() {
                
        switch self.type {
            
        case .xe:
            XEWallet().downloadTransactions(address: self.address, completion: { transactions in
            
                if let trans = transactions {
                
                    self.transactions = TransactionsDataModel(from: trans)
                }
                
                XEWallet().downloadPendingTransactions(address: self.address, completion: { transactions in
                
                    if let trans = transactions {
                    
                        var newArray = [TransactionRecordDataModel]()
                        for t in trans {

                            let newRecord = TransactionRecordDataModel(from: t)
                            newArray.append(newRecord)
                        }
                        
                        if self.transactions?.results == nil {
                            
                            self.transactions?.results = [TransactionRecordDataModel]()
                        }
                        
                        self.transactions?.results?.append(contentsOf: newArray)
                    }
                    NotificationCenter.default.post(name: .didReceiveData, object: nil)
                })
            })
            break
            
        case .ethereum:
            EtherWallet().downloadTransactions(address: self.address, completion: { transactions in
                
                if let trans = transactions {
                    
                    self.transactions = TransactionsDataModel(from: trans, type: .ethereum)
                }

                EtherWallet().downloadTokenTransations(address: self.address, completion: { transactions in
                    
                    if let trans = transactions {
                    
                        if self.transactions == nil {
                            
                            self.transactions = TransactionsDataModel(from: trans, type: .edge)
                        } else {
                            
                            if let results = TransactionsDataModel(from: trans, type: .edge).results {
                            
                                self.transactions?.results?.append(contentsOf: results)
                            }
                        }
                    }
                })
            })
            break
            
        case .edge:
            break
            
        case .usdc:
            break
        }
    }
    
}
