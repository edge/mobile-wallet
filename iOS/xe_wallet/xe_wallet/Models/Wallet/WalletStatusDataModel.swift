//
//  XEWalletDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 16/11/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class WalletStatusDataModel: Codable {

    var address: String
    var balance: Double
    var edgeBalance: Double
    var nonce: Int

    enum CodingKeys: String, CodingKey {
        
        case address
        case balance
        case edgeBalance
        case nonce
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decode(String.self, forKey: .address)
        self.balance = try container.decode(Double.self, forKey: .balance)
        self.edgeBalance = try container.decodeIfPresent(Double.self, forKey: .edgeBalance) ?? 0
        self.nonce = try container.decode(Int.self, forKey: .nonce)
    }
    
    public init(address: String, balance: Double, nonce: Int) {
        
        self.address = address
        self.balance = balance
        self.edgeBalance = 0
        self.nonce = nonce
    }
    
    public init(from xe: XEWalletStatusDataModel) {
        
        self.address = xe.address ?? ""
        self.balance = Double(xe.balance ?? 0)/1000000
        self.edgeBalance = 0
        self.nonce = xe.nonce ?? 0
    }
    
    public init(from ether: EtherWalletStatusDataModel) {
        
        self.address = ether.address ?? ""
        self.balance = Double(ether.balance ?? 0)///1000000
        self.edgeBalance = Double(ether.edgeBalance ?? 0)
        self.nonce = ether.nonce ?? 0
    }
}

