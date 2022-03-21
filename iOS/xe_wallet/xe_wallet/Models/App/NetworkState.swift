//
//  Network.swift
//  xe_wallet
//
//  Created by Paul Davis on 27/11/2021.
//

import Foundation

enum NetworkState: String, Codable {
    
    case main = "Edge (XE) Mainnet"
    case test = "Edge (XE) Testnet"
    
    func getStatusString() -> String {
        
        switch self {
                        
        case .main:
            return "main"
                        
        case .test:
            return "test"
        }
    }
    

    func getWithdrawBridgeAddress() -> String {
                    
        switch self {
                        
        case .main:
            return "xe_A4788d8201Fb879e3b7523a0367401D2a985D42F"
                        
        case .test:
            return "xe_BEE3d7E5f007b662B2C886d51e2B3E08de090488"
        }
    }
    
    func getDepositBridgeAddress() -> String {
                    
        switch self {
                        
        case .main:
            return "0x857a9b116074466F56f1360c09b6BF9E898964Fe"
                        
        case .test:
            return "0xC456173cEcB6E5EF1e86c38af322E024f2193B26"
        }
    }
    
    func getDepositTokenAddress() -> String {
                    
        switch self {
                        
        case .main:
            return "0x4ec1b60b96193a64acae44778e51f7bff2007831"
                        
        case .test:
            return "0xbf57cd6638fdfd7c4fa4c10390052f7ab3a1c301"
        }
    }
    
    func getUSDCBridgeAddress() -> String {
                    
        switch self {
                        
        case .main:
            return "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
                        
        case .test:
            return "0xa279968cc3ac93640bee947322f1e5f94fda6fc5"
        }
    }
        
    func getABIContactUrl() -> String {
                    
        switch self {
                        
        case .main:
            return "https://raw.githubusercontent.com/edge/bridge-utils/master/dist/artifacts/token.json"
                        
        case .test:
            return "https://raw.githubusercontent.com/edge/bridge-utils/master/dist/artifacts/token.json"
        }
    }
    /*
    func getInfuraUrl() -> String {
                    
        switch self {
                        
        case .main:
            return "https://mainnet.infura.io/v3/f4953edd390547d3bb63dd1f76af13f2"
                        
        case .test:
            return "https://rinkeby.infura.io/v3/f4953edd390547d3bb63dd1f76af13f2"
        }
    }*/
}
