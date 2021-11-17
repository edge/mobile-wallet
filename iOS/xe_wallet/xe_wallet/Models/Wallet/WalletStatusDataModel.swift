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
    var balance: Int
    var nonce: Int

    enum CodingKeys: String, CodingKey {
        
        case address
        case balance
        case nonce
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decode(String.self, forKey: .address)
        self.balance = try container.decode(Int.self, forKey: .balance)
        self.nonce = try container.decode(Int.self, forKey: .nonce)
    }
    
    public init(address: String) {
        
        self.address = address
        self.balance = 0
        self.nonce = 0
    }
    
    
}

