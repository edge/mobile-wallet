//
//  WalletTypes.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation

enum WalletType: String {
    
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
}
