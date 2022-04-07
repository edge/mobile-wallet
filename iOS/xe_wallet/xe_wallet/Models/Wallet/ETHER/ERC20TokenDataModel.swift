//
//  ERC20TokenDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 26/02/2022.
//

import Foundation
import web3swift

enum ERC20TokenType: String, Codable, CaseIterable {
    
    case edge = "coin_edge"
    case usdc = "coin_usdc"
    
    func getTokenUnitType() -> Web3.Utils.Units {
        
        switch self {
            
        case .edge:
            return .wei
        case .usdc:
            return .Microether
        }
    }
    
    func getMainType() -> WalletType {
        
        switch self {
            
        case .edge:
            return WalletType.edge
        case .usdc:
            return WalletType.usdc
        }
    }
    
    func getDisplayLabel() -> String {
        
        switch self {
            
        case .edge:
            return "Edge"
            
        case .usdc:
            return "USDC"
        }
    }
    
    func getFullNameLabel() -> String {
        
        switch self {

        case .edge:
            return "Edge"

        case .usdc:
            return "USDC"
        }
    }
    
    func getCoinSymbol() -> String {
        
        switch self {

        case .edge:
            return "Edge"

        case .usdc:
            return "USDC"
        }
    }
    
    func getContractAddress() -> String {
        
        switch self {
            
        case .edge:
            if AppDataModelManager.shared.getNetworkStatus() == .test {
                
                return "0xbf57cd6638fdfd7c4fa4c10390052f7ab3a1c301"
            } else {
                
                return "0x4ec1b60b96193a64acae44778e51f7bff2007831"
            }
        
        case .usdc:
            if AppDataModelManager.shared.getNetworkStatus() == .test {
            
                return "0xA279968Cc3Ac93640bEe947322F1e5f94FDA6fC5"
            } else {
            
                return "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
            }
        }
    }
}

class ERC20TokenDataModel: Codable {

    var type: WalletType
    var tokenType: ERC20TokenType
    var balance: Double

    enum CodingKeys: String, CodingKey {
        
        case type
        case tokenType
        case balance
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(WalletType.self, forKey: .type)
        self.tokenType = try container.decode(ERC20TokenType.self, forKey: .type)
        self.balance = try container.decode(Double.self, forKey: .balance)
    }
    
    public init(type: WalletType, tokenType: ERC20TokenType, balance: Double) {
        
        self.type = type
        self.tokenType = tokenType
        self.balance = balance
    }
}
