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
    var erc20Tokens: [ERC20TokenDataModel]?
    var nonce: Int

    enum CodingKeys: String, CodingKey {
        
        case address
        case balance
        case erc20Tokens
        case nonce
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decode(String.self, forKey: .address)
        self.balance = try container.decode(Double.self, forKey: .balance)
        self.erc20Tokens = try container.decodeIfPresent([ERC20TokenDataModel].self, forKey: .erc20Tokens)
        self.nonce = try container.decode(Int.self, forKey: .nonce)
    }
    
    public init(address: String, balance: Double, erc20Tokens: [ERC20TokenDataModel]?, nonce: Int) {
        
        self.address = address
        self.balance = balance
        self.erc20Tokens = erc20Tokens
        self.nonce = nonce
    }
    
    public func getTokenBalance(type: ERC20TokenType) -> Double {
        
        if let erc20 = self.erc20Tokens {
            
            if let index = erc20.firstIndex(where: { $0.tokenType == type }) {
                
                return erc20[index].balance
            }
        }
        return 0.0
    }
}

