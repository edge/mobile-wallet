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
    var transactions: [TransactionDataModel]?
    var pending: [TransactionDataModel]?
    var wallet: Wallet?
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case address
        case created
        case backedup
        case status
        case transactions
        case pending
        case wallet
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(WalletType.self, forKey: .type)
        self.address = try container.decode(String.self, forKey: .address)
        self.created = try container.decode(Double.self, forKey: .created)
        self.backedup = try container.decode(Double.self, forKey: .backedup)
        self.status = try container.decodeIfPresent(WalletStatusDataModel.self, forKey: .status)
        self.transactions = try container.decodeIfPresent([TransactionDataModel].self, forKey: .transactions)
        self.pending = try container.decodeIfPresent([TransactionDataModel].self, forKey: .pending)
        self.wallet = try container.decodeIfPresent(Wallet.self, forKey: .wallet)
    }
    
    public init(type: WalletType, wallet: AddressKeyPairModel) {
        
        self.type = type
        self.address = wallet.address
        self.created = Date().timeIntervalSince1970
        self.backedup = Date().timeIntervalSince1970

        self.status = WalletStatusDataModel(address: wallet.address, balance: 0, erc20Tokens: nil, nonce: 0)
        self.transactions = nil
        
        self.wallet = wallet.wallet
    }
    
    func downloadXETransactionBlock(address: String, count: Int, page: Int, block: Int, completion: @escaping (Int)-> Void) {
        
        XEWallet().downloadAllTransactions(address: address, page: page, block: block, completion: { response, resCount, resTotalCount in
        
            if let transactions = response {
                
                if self.transactions == nil {
                    
                    self.transactions = []
                }
                
                for trans in transactions {
                    
                    if let index = self.transactions?.firstIndex(where: { $0.hash == trans.hash }) {
                    
                        self.transactions?[index] = trans
                    } else {
                        
                        self.transactions?.append(trans)
                    }
                }
                var newCount = count + resCount
                if newCount >= resTotalCount {
                    
                    completion(0)
                } else {
                    
                    self.downloadXETransactionBlock(address: address, count: newCount, page: page+1, block: block, completion: completion)
                }
            }
        })
    }
    
    
    func downloadWalletStatus() {
                
        self.type.downloadWalletStatus(address: self.address, completion: { status in
            
            self.status = status
        })
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
    }
    
    func downloadWalletTransactions() {
                
        self.type.downloadTransactions(address: self.address, completion: { status in
            
            self.transactions = status
            
            if let tokens = self.status?.erc20Tokens {
                
                for token in tokens {
                    
                    if token.type == .edge {
                        self.type.downloadTokenTransactions(address: self.address, completion: { transactions in
                            
                            var oldArray: [TransactionDataModel] = self.transactions ?? []
                            if let trans = transactions {
                                
                                for tran in trans {
                                    
                                    if let index = oldArray.firstIndex(where: { $0.hash == tran.hash }) {
                                        
                                        oldArray.remove(at: index)
                                    }
                                }
                                
                                oldArray.append(contentsOf: trans)
                            }
                            self.transactions = oldArray
                        })
                    }
                }
            }
        })
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
    }
}
