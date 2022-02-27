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
            
        case .edge, .ethereum, .usdc:
            return 0.001000
        }
    }
    
    func getWalletCharacterLength() -> Int {
        
        switch self {
            
        case .xe:
            return 43
            
        case .edge, .ethereum, .usdc:
            return 42
        }
    }
    
    func getWalletPrefix() -> String {
        
        switch self {
            
        case .xe:
            return "xe_"
            
        case .edge, .ethereum, .usdc:
            return "0x"
        }
    }
    
    func getExploreButtonText() -> String {
        
        switch self {
            
        case .xe:
            return "View on Explorer"
            
        case .edge, .ethereum, .usdc:
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
            
        case .edge, .ethereum, .usdc:
            if AppDataModelManager.shared.testModeStatus() {
            
                return "https://rinkeby.etherscan.io/tx/"
            } else {
                
                return "https://etherscan.io/tx/"
            }
        }
    }

    
    func createWallet() -> AddressKeyPairModel? {
        
        switch self {
            
        case .xe:
            return XEWallet().generateWallet(type: .xe)
            
        case .edge, .ethereum, .usdc:
            return EtherWallet().generateWallet(type: .ethereum)
        }
    }
    
    func restoreWallet(key: String) -> AddressKeyPairModel? {
        
        switch self {
            
        case .xe:
            return XEWallet().generateWalletFromPrivateKey(privateKeyString: key)
            
        case .ethereum, .edge, .usdc:
            return EtherWallet().generateWalletFromPrivateKey(privateKeyString: key)
        }
    }
    
    func downloadWalletStatus(address: String, completion: @escaping (WalletStatusDataModel?)-> Void) {
        
        switch self {
            
        case .xe:
            XEWallet().downloadStatus(address: address, completion: { status in
            
                completion(status)
            })
            
        case .ethereum, .edge, .usdc:
            EtherWallet().downloadStatus(address: address, completion: { status in
                
                completion(status)
            })
        }
    }
    
    func downloadTransactions(address: String, completion: @escaping ([TransactionDataModel]?)-> Void) {
        
        switch self {
            
        case .xe:
            XEWallet().downloadTransactions(address: address, completion: { status in
            
                completion(status)
            })
            
        case .ethereum, .edge, .usdc:
            EtherWallet().downloadTransactions(address: address, completion: { status in
                
                completion(status)
            })
        }
    }
    
    func downloadTokenTransactions(address: String, completion: @escaping ([TransactionDataModel]?)-> Void) {
        
        switch self {
            
        case .xe:
            break
            
        case .ethereum, .edge, .usdc:
            EtherWallet().downloadTokenTransations(address: address, type: self, completion: { status in
                
                completion(status)
            })
        }
    }

    func sendCoins(wallet: WalletDataModel, toAddress: String, memo: String, amount: String, key: String, completion: @escaping (Bool)-> Void) {
        
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
    
    func exchangeCoins(wallet: WalletDataModel, toAddress: String, amount: String, fee: Double, key: String, completion: @escaping (Bool)-> Void) {
        
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
