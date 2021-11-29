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
    
    //var xeWallet: XEWalletDataModel?
    //var etherWallet: EtherWalletDataModel?
    
    var status: WalletStatusDataModel?
    var transactions: TransactionsDataModel?
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case address
        case created
        case backedup
        //case xeWallet
        //case etherWallet
        
        case status
        case transactions
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(WalletType.self, forKey: .type)
        self.address = try container.decode(String.self, forKey: .address)
        self.created = try container.decode(Double.self, forKey: .created)
        self.backedup = try container.decode(Double.self, forKey: .backedup)
        //self.xeWallet = try container.decodeIfPresent(XEWalletDataModel.self, forKey: .xeWallet)
        //self.etherWallet = try container.decodeIfPresent(EtherWalletDataModel.self, forKey: .etherWallet)
        
        self.status = try container.decode(WalletStatusDataModel.self, forKey: .status)
        self.transactions = nil
        
        self.downloadWalletStatus()
        self.downloadWalletTransactions()
    }
    
    public init(type: WalletType, address: String) {
        
        self.type = type
        self.address = address
        self.created = Date().timeIntervalSince1970
        self.backedup = Date().timeIntervalSince1970
                        
        /*if type == .xe {
            
            self.xeWallet = XEWalletDataModel(address: address)
        } else if type == .ethereum {
            
            self.etherWallet = EtherWalletDataModel(address: address)
        }*/
        
        self.status = WalletStatusDataModel(address: address, balance: 0, nonce: 0)
        self.transactions = nil
        
        self.downloadWalletStatus()
        self.downloadWalletTransactions()
    }
    
    func downloadWalletStatus() {
                
        switch self.type {
            
        case .xe:
            XEWallet().downloadStatus(address: self.address, completion: { status in
            
                if let stat = status {
                
                    self.status = WalletStatusDataModel(from: stat)
                }
            })
            break
            
        case .ethereum:
            EtherWallet().downloadStatus(address: self.address, completion: { status in
                
                if let stat = status {
                
                    self.status = WalletStatusDataModel(from: stat)
                }
            })
            break
            
        case .edge:
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
            })
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
                    
                    if var oldTrans = self.transactions?.results {
                        
                        oldTrans.insert(contentsOf: newArray, at: 0)
                        self.transactions?.results = oldTrans
                    }

                }
            })
            NotificationCenter.default.post(name: .didReceiveData, object: nil)
            break
            
        case .ethereum:
            EtherWallet().downloadStatus(address: self.address, completion: { status in
                
                if let stat = status {
                
                    self.status = WalletStatusDataModel(from: stat)
                }
            })
            break
            
        case .edge:
            break
        }
    }
    
}
