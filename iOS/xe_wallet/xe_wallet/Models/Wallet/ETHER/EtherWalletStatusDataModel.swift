//
//  EtherWalletStatusDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 27/11/2021.
//

import Foundation

class EtherWalletStatusDataModel: Codable {

    var address: String?
    var balance: Double?
    var nonce: Int?
    var edgeBalance: Double?

    enum CodingKeys: String, CodingKey {
        
        case address
        case balance
        case nonce
        case edgeBalance
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.balance = try container.decodeIfPresent(Double.self, forKey: .balance)
        self.nonce = try container.decodeIfPresent(Int.self, forKey: .nonce)
        self.edgeBalance = try container.decodeIfPresent(Double.self, forKey: .edgeBalance)
    }
    
    public init(address: String, balance: Double, nonce: Int, edgeBalance: Double) {
        
        self.address = address
        self.balance = balance
        self.nonce = nonce
        self.edgeBalance = edgeBalance
    }
}
