//
//  XEWalletStatusDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 26/11/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class XEWalletStatusDataModel: Codable {

    var address: String?
    var balance: Int?
    var nonce: Int?

    enum CodingKeys: String, CodingKey {
        
        case address
        case balance
        case nonce
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.balance = try container.decodeIfPresent(Int.self, forKey: .balance)
        self.nonce = try container.decodeIfPresent(Int.self, forKey: .nonce)
    }
    
    public init(address: String, balance: Int, nonce: Int) {
        
        self.address = address
        self.balance = balance
        self.nonce = nonce
    }
}
