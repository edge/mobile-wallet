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
    case usdc = "coin_usdc"
    
    func getDisplayLabel() -> String {
        
        switch self {
            
        case .xe:
            return "XE"
            
        case .edge:
            return "Edge"
            
        case .ethereum:
            return "Ether"
            
        case .usdc:
            return "USDC"
        }
    }

    func getFullNameLabel() -> String {
        
        switch self {
            
        case .xe:
            return "XE"
            
        case .edge:
            return "Edge"
            
        case .ethereum:
            return "Ethereum"
            
        case .usdc:
            return "USDC"
        }
    }
    
    func getCoinSymbol() -> String {
        
        switch self {
            
        case .xe:
            return "XE"
            
        case .edge:
            return "EDGE"
            
        case .ethereum:
            return "ETH"
            
        case .usdc:
            return "USDC"
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
            
        case .usdc:
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
            
        case .usdc:
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
            
        case .usdc:
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
            
        case .usdc:
            return "0x"
        }
    }
    
    func getExploreButtonText() -> String {
        
        switch self {
            
        case .xe:
            return "View on Explorer"
            
        case .edge:
            return "View on Etherscan"
            
        case .ethereum:
            return "View on Etherscan"
            
        case .usdc:
            return "View on Etherscan"
        }
    }
    
    func getExploreButtonUrl() -> String {
        
        switch self {
            
        case .xe:
            if AppDataModelManager.shared.testModeStatus() {
                
                return "https://test.network/transaction/"
            } else {
                
                return "https://xe.network/transaction/"
            }
            
        case .edge:
            if AppDataModelManager.shared.testModeStatus() {
            
                return "https://rinkeby.etherscan.io/tx/"
            } else {
                
                return "https://etherscan.io/tx/"
            }
            
        case .ethereum:
            if AppDataModelManager.shared.testModeStatus() {
                
                return "https://rinkeby.etherscan.io/tx/"
            } else{
                
                return "https://etherscan.io/tx/"
            }
            
        case .usdc:
            if AppDataModelManager.shared.testModeStatus() {
                
                return "https://rinkeby.etherscan.io/tx/"
            } else{
                
                return "https://etherscan.io/tx/"
            }
        }
    }

    
    func createWallet() -> AddressKeyPairModel? {
        
        switch self {
            
        case .xe:
            return XEWallet().generateWallet(type: .xe)
            
        case .edge:
            return EtherWallet().generateWallet(type: .ethereum)
            
        case .ethereum:
            return EtherWallet().generateWallet(type: .ethereum)
            
        case .usdc:
            return EtherWallet().generateWallet(type: .ethereum)
        }
    }
    
    public func restoreWallet(key: String) -> AddressKeyPairModel? {
        
        switch self {
            
        case .xe:
            return XEWallet().generateWalletFromPrivateKey(privateKeyString: key)
            
        case .ethereum:
            return EtherWallet().generateWalletFromPrivateKey(privateKeyString: key)
            
        case .edge:
            return EtherWallet().generateWalletFromPrivateKey(privateKeyString: key)
            
        case .usdc:
            return EtherWallet().generateWalletFromPrivateKey(privateKeyString: key)
        }
    }

    public func sendCoins(wallet: WalletDataModel, toAddress: String, memo: String, amount: String, key: String, completion: @escaping (Bool)-> Void) {
        
        switch self {
            
        case .xe:
            XEWallet().sendCoins(wallet: wallet, toAddress: toAddress, memo: memo, amount: amount, key: key, completion: { res in
                
                completion( res )
            })
            break
            
        case .edge:
            EtherWallet().sendEdge(toAddr: toAddress, wallet: wallet, amt: amount, key: key, completion: { res in
                
                completion( res )
            })
            break
            
        case .usdc:
            EtherWallet().sendEdge(toAddr: toAddress, wallet: wallet, amt: amount, key: key, completion: { res in
                
                completion( res )
            })
            break
            
        case .ethereum:
            
            EtherWallet().sendEther(toAddr: toAddress, wallet: wallet, amt: amount, key: key, completion: { res in
                
                completion( res )
            })
            break
        }
    }
    
    public func exchangeCoins(wallet: WalletDataModel, toAddress: String, amount: String, fee: Double, key: String, completion: @escaping (Bool)-> Void) {
        
        switch self {
            
        case .xe:
            XEWallet().withdrawCoins(wallet: wallet, toAddress: toAddress, amount: amount, fee: fee, key: key, completion: { res in
                
                completion( res )
            })
            break
            
        case .ethereum:
            EtherWallet().depositCoins(wallet: wallet, toAddress: toAddress, amount: amount, key: key, completion: { res in
                
                completion( res )
            })
            break
            
        case .edge:
            break
            
        case .usdc:
            break
        }
    }
}
