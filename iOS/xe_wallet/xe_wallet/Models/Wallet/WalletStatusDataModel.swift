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
    //var edgeBalance: Double
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
    
    public init(from xe: XEWalletStatusDataModel) {
        
        self.address = xe.address ?? ""
        self.balance = Double(xe.balance ?? 0)/1000000
        self.erc20Tokens = nil
        self.nonce = xe.nonce ?? 0
    }
    
    public init(from ether: EtherWalletStatusDataModel) {
        
        self.address = ether.address ?? ""
        self.balance = Double(ether.balance ?? 0)///1000000
        self.erc20Tokens = ether.erc20Tokens
        self.nonce = ether.nonce ?? 0
    }
    
    public func getTokenBalance(type: ERC20TokenType) -> Double {
        
        if let erc20 = self.erc20Tokens {
            
            if let index = erc20.firstIndex(where: { $0.type == type }) {
                
                return erc20[index].balance
            }
        }
        return 0.0
    }
}

