//
//  WalletTypes.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation
import web3swift

enum WalletStringData {
    
    case displayLabel
    case fullNameLabel
    case coinSymbolLabel
    case backgroundImage
    case coinPrefix
    case explorerButtonText
}

enum WalletNetworkStringData {
    
    case status
    case gasRates
    case gasExchangeRates
    case gasExchangeCurrent
    case gasExchangeHistory
    case send
    case transaction
    case pendingTransaction
    case exploreButtonUrl
}

enum WalletType: String, Codable {
    
    case xe = "coin_xe"
    case edge = "coin_edge"
    case ethereum = "coin_ethereum"
    case usdc = "coin_usdc"
    
    func getDataString(dataType: WalletStringData) -> String {
        
        switch self {
            
        case .xe:
            switch dataType {
                
            case .displayLabel, .fullNameLabel, .coinSymbolLabel:
                return "XE"
            case .backgroundImage:
                return "credit_card_xe"
            case .coinPrefix:
                return "xe_"
            case .explorerButtonText:
                return "View on Explorer"
            }
            
        case .edge:
            switch dataType {
                
            case .displayLabel, .fullNameLabel:
                return "Edge"
            case .coinSymbolLabel:
                return "EDGE"
            case .backgroundImage:
                return "credit_card_xe"
            case .coinPrefix:
                return "0x"
            case .explorerButtonText:
                return "View on Etherscan"
            }
            
        case .ethereum:
            switch dataType {
                
            case .displayLabel:
                return "Ether"
            case .fullNameLabel:
                return "Ethereum"
            case .coinSymbolLabel:
                return "ETH"
            case .backgroundImage:
                return "credit_card_ether"
            case .coinPrefix:
                return "0x"
            case .explorerButtonText:
                return "View on Etherscan"
            }
            
        case .usdc:
            switch dataType {
                
            case .displayLabel, .fullNameLabel, .coinSymbolLabel:
                return "USDC"
            case .backgroundImage:
                return "credit_card_ether"
            case .coinPrefix:
                return "0x"
            case .explorerButtonText:
                return "View on Etherscan"
            }
        }
    }

    func getDataNetwork(dataType: WalletNetworkStringData) -> String {
        
        if AppDataModelManager.shared.testModeStatus() {
            
            switch self {
                
            case .xe:
                switch dataType {
                    
                case .status:
                    return "https://xe1.test.network/wallet/"
                case .gasRates:
                    return "https://index.test.network/gasrates"
                case .gasExchangeRates:
                    return "https://index.test.network/exchangerate"
                case .gasExchangeCurrent:
                    return "https://index.test.network/token/current"
                case .gasExchangeHistory:
                    return "https://index.test.network/token/lastweek"
                case .send:
                    return "https://xe1.test.network/transaction"
                case .transaction:
                    return "https://index.test.network/transactions/"
                case .pendingTransaction:
                    return "https://xe1.test.network/transactions/pending/"
                case .exploreButtonUrl:
                    return "https://test.network/transaction/"
                }
                
            case .edge, .ethereum, .usdc:
                switch dataType {
                    
                case .status, .gasRates, .gasExchangeRates, .gasExchangeCurrent, .gasExchangeHistory, .send, .transaction, .pendingTransaction:
                    return ""
                        
                case .exploreButtonUrl:
                    return "https://rinkeby.etherscan.io/tx/"
                }
            }
        } else {
            
            switch self {
                
            case .xe:
                switch dataType {
                    
                case .status:
                    return "https://api.xe.network/wallet/"
                case .gasRates:
                    return "https://index.xe.network/gasrates"
                case .gasExchangeRates:
                    return "https://index.xe.network/exchangerate"
                case .gasExchangeCurrent:
                    return "https://index.xe.network/token/current"
                case .gasExchangeHistory:
                    return "https://index.xe.network/token/lastweek"
                case .send:
                    return "https://api.xe.network/transaction"
                case .transaction:
                    return "https://index.xe.network/transactions/"
                case .pendingTransaction:
                    return "https://api.xe.network/transactions/pending/"
                case .exploreButtonUrl:
                    return "https://xe.network/transaction/"
                }
                
            case .edge, .ethereum, .usdc:
                switch dataType {
                    
                case .status, .gasRates, .gasExchangeRates, .gasExchangeCurrent, .gasExchangeHistory, .send, .transaction, .pendingTransaction:
                    return ""
                case .exploreButtonUrl:
                    return "https://etherscan.io/tx/"
                }
            }
        }
        return ""
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
    
    func getGasString(amount: String, fromAddress: String, toAddress: String) -> String {
        
        switch self {
            
        case .xe:
            return ""
            
        case .ethereum, .edge, .usdc:
            return EtherWallet().getGasString(amount: amount, fromAddress: fromAddress, toAddress: toAddress)
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

    func createSendTX(wallet: WalletDataModel, toAddress: String, memo: String, amount: String, key: String ) -> WriteTransaction? {
        
        switch self {
            
        case .xe:
            break
            
        case .edge:
            break
            
        case .usdc:
            break
            
        case .ethereum:
            return EtherWallet().createSendEtherTX(toAddr: toAddress, wallet: wallet, amt: amount, key: key)
            break
        }
        return nil
    }
    
    func sendCoins(wallet: WalletDataModel, toAddress: String, memo: String, amount: String, key: String, completion: @escaping (Bool, String)-> Void) {
        
        switch self {
            
        case .xe:
            XEWallet().sendCoins(wallet: wallet, toAddress: toAddress, memo: memo, amount: amount, key: key, completion: { res, error  in
                
                completion( res, error )
            })
            break
            
        case .edge:
            EtherWallet().sendEdge(toAddr: toAddress, wallet: wallet, amt: amount, key: key, completion: { res in
                
                completion( res, "" )
            })
            break
            
        case .usdc:
            break
            
        case .ethereum:
            
            EtherWallet().sendEther(toAddr: toAddress, wallet: wallet, amt: amount, key: key, completion: { res in
                
                completion( res, "" )
            })
            break
        }
    }
    
    func exchangeCoins(wallet: WalletDataModel, toAddress: String, toType: WalletType, amount: String, fee: Double, key: String, completion: @escaping (Bool)-> Void) {
        
        switch self {
            
        case .xe:
            XEWallet().withdrawCoins(wallet: wallet, toAddress: toAddress, toType: toType, amount: amount, fee: fee, key: key, completion: { res in
                
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
