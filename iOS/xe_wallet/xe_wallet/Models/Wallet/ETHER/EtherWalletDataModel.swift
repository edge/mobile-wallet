//
//  EtherWalletDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 27/11/2021.
//

import Foundation
import web3swift
//import Web3

class EtherWalletDataModel: Codable {

    var address: String
    var status: EtherWalletStatusDataModel?
    var transactions: EtherTransactionsDataModel?
    
    enum CodingKeys: String, CodingKey {
        
        case address
        case status
        case transactions
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decode(String.self, forKey: .address)
        self.status = try container.decodeIfPresent(EtherWalletStatusDataModel.self, forKey: .status)
        self.transactions = try container.decodeIfPresent(EtherTransactionsDataModel.self, forKey: .transactions)
    }
    
    public init(address: String) {
        
        self.address = address
        self.status = nil
        self.transactions = nil
    }
}
