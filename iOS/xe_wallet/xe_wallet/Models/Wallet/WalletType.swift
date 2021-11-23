//
//  WalletTypes.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation

enum WalletType: String, Codable {
    
    case xe = "coin_xe"
    case edge = "coin_edge"
    case ethereum = "coin_ethereum"
    
    func getDisplayLabel() -> String {
        
        switch self {
            
        case .xe:
            return "XE"
            
        case .edge:
            return "Edge"
            
        case .ethereum:
            return "Ether"
        }
    }
    
    func getBackgroundImage() -> String {
        
        switch self {
            
        case .xe:
            return "credit_card_xe"
            
        case .edge:
            return "credit_card_xe"
            
        case .ethereum:
            return "credit_card_ether"
        }
    }
    
    func getMinSendValue() -> Double {
        
        switch self {
            
        case .xe:
            return 0.000001
            
        case .edge:
            return 0.001000
            
        case .ethereum:
            return 0.001000
        }
    }
    
    func getWalletCharacterLength() -> Int {
        
        switch self {
            
        case .xe:
            return 43
            
        case .edge:
            return 42
            
        case .ethereum:
            return 42
        }
    }
    
    func getWalletPrefix() -> String {
        
        switch self {
            
        case .xe:
            return "xe_"
            
        case .edge:
            return "0x"
            
        case .ethereum:
            return "0x"
        }
    }
}
