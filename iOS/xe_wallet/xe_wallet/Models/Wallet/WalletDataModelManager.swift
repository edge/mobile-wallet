//
//  WalletDataModelManager.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation
import secp256k1
import SwiftKeccak
import UIKit
import Security

class WalletDataModelManager {

    static let shared = WalletDataModelManager()
    
    var walletData = [WalletDataModel]()
    var selectedWalletAddress = ""
    var exchangeRefreshNeeded = true
    
    var timerUpdate: Timer?
    
    var latestTransaction: TransactionDataModel? = nil
    var latestTransactionWallet: WalletDataModel? = nil
    
    private init() {
        
        self.loadWalletList()
        self.loadLatestTransaction()
        self.reloadAllWalletInformation()
        self.timerUpdate = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { timer in
            
            self.reloadAllWalletInformation()
        }
    }
        
    func loadWalletList() {

        if let data = UserDefaults.standard.data(forKey: Constants.defaultStorageName) {
            
            self.walletData = try! JSONDecoder().decode([WalletDataModel].self, from: data)
        }
    }
    
    public func saveWalletData() {
        
        self.exchangeRefreshNeeded = true
        
        let wData = try! JSONEncoder().encode(self.walletData)
        UserDefaults.standard.set(wData, forKey: Constants.defaultStorageName)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
    }
    
    public func saveWalletToSystem(wallet:AddressKeyPairModel, type: WalletType) {
        
        let username = wallet.address
        let password = wallet.privateKey.data(using: .utf8)!
        
        do {
            
            try KeychainHelper.update(password: password, account: username)
            let wallet = WalletDataModel(type: type, wallet: wallet)
            self.walletData.append(wallet)
            self.saveWalletData()
        } catch {
        
            do {
                
                try KeychainHelper.save(password: password, account: username)
                let wallet = WalletDataModel(type: type, wallet: wallet)
                self.walletData.append(wallet)
                self.saveWalletData()
            } catch {
            }
        }
    }
    
    public func activeWalletAmount() -> Int {
        
        return self.walletData.count
    }
    
    public func getWalletData() -> [WalletDataModel] {
        
        return self.walletData
    }
    
    public func loadWalletKey(key:String) -> String {
        
        let username = key

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?

        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {

            if let existingItem = item as? [String: Any],
               let _ = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8) {
                
                return password
            }
        }
        return ""
    }
    
    private func loadLatestTransaction() {
        
        do {
            
            if let trans = UserDefaults.standard.data(forKey: "LatestTransaction") {
            
                self.latestTransaction = try JSONDecoder().decode(TransactionDataModel.self, from: trans)
            }
            if let wallet = UserDefaults.standard.data(forKey: "LatestTransactionWallet") {
            
               self.latestTransactionWallet = try JSONDecoder().decode(WalletDataModel.self, from: wallet)
            }
        } catch {
        }
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
    }
    
    private func saveLatestTransaction() {
        
        if let trans = self.latestTransaction {
        
            let tran = try! JSONEncoder().encode(trans)
            UserDefaults.standard.set(tran, forKey: "LatestTransaction")
        }
        if let wallet = self.latestTransactionWallet {
        
            let wall = try! JSONEncoder().encode(wallet)
            UserDefaults.standard.set(wall, forKey: "LatestTransactionWallet")
        }
        UserDefaults.standard.synchronize()
    }
    
    
    public func reloadAllWalletInformation() {
        
        self.calculateLatestTransaction()
        
        var xeAddresses: [String] = []
        for wallet in self.walletData {
            
            if wallet.type == .xe {
            
                xeAddresses.append(wallet.address)
            } else {
                
                wallet.downloadWalletStatus()
                wallet.downloadWalletTransactions()
            }
        }
        self.handleXEUpdates(addresses: xeAddresses)
    }
    
    private func handleXEUpdates(addresses: [String]) {
                
        XEWallet().downloadAllWalletData(addresses: addresses, completion: { response in
        
            guard let summary = response else { return }
            guard let balances = summary.balances else { return }

            for balance in balances {
                
                if let index = self.walletData.firstIndex(where: { $0.address == balance.address }) {
                    
                    self.walletData[index].status = WalletStatusDataModel(address: balance.address ?? "", balance: Double(balance.balance ?? 0)/1000000, erc20Tokens: nil, nonce: balance.nonce ?? 0)
                    
                    if let latestTx = balance.latestTx {
                        
                        if let block = latestTx.block {
                            
                            var cachedBlock = 0
                            var downloadTransactions = true
                            if let cachedTransactions = self.walletData[index].transactions {

                                for trans in cachedTransactions {
                                    
                                    if let tBlock = trans.block {
                                        
                                        if tBlock.height > cachedBlock {
                                            
                                            cachedBlock = tBlock.height ?? 0
                                        }
                                        if tBlock.height == block {
                                            
                                            downloadTransactions = false
                                        }
                                    }
                                }
                            }
                            
                            if downloadTransactions {
                                                     
                                //self.walletData[index].transactions = []
                                
                                self.walletData[index].downloadXETransactionBlock(address: balance.address ?? "", count: 0, page: 1, block:cachedBlock, completion: { response in
                                    
                                    self.saveWalletData()
                                })
                            }
                        }
                    }
                }
            }
        })
    }

    
    
    public func getInitialWalletAddress() -> String {
        
        if self.walletData.count > 0 {
            
            return self.walletData[0].address
        }
        
        return ""
    }
    
    public func getWalletDataWithAddress(address: String) -> WalletDataModel? {
        
        if let index = self.walletData.firstIndex(where: { $0.address == address }) {
            
            return self.walletData[index]
        }
        return nil
    }
    
    public func switchWalletPosition(aIndex: Int, bIndex: Int) {
        
        let movedObject = self.walletData[aIndex]
        self.walletData.remove(at: aIndex)
        self.walletData.insert(movedObject, at: bIndex)
        self.saveWalletData()
    }
    
    public func getExchangeOptions(type: WalletType) -> [WalletDataModel] {
        
        let filtered = self.walletData.filter { $0.type != type }
        return filtered
    }
    
    public func getSelectedWalletData(address: String) -> WalletDataModel? {
        
        if let i = self.walletData.firstIndex(where: { $0.address == address }) {
            
            return self.walletData[i]
        }
        return nil
    }
    
    public func getWalletTypeFromAddress(address: String) -> WalletType? {
        
        if let i = self.walletData.firstIndex(where: { $0.address == address }) {
            
            return self.walletData[i].type
        }
        return nil
    }
        
    public func getLatestTransaction() -> (transaction: TransactionDataModel?, wallet: WalletDataModel?) {
        
        return (self.latestTransaction, self.latestTransactionWallet)
    }
    
    public func calculateLatestTransaction() {
            
        var transaction: TransactionDataModel? = nil
        var wallet: WalletDataModel? = nil
        
        if self.walletData.count == 0 {
            
            return
        }
        
        for wall in self.walletData {
            
            if let transactions = wall.transactions {
                
                for trans in transactions {
                    
                    if transaction == nil {
                        
                        transaction = trans
                        wallet = wall
                    } else {
                        
                        if trans.timestamp > transaction?.timestamp ?? 0 {
                            
                            transaction = trans
                            wallet = wall
                        }
                    }
                }
            }
        }
            
        if transaction != nil && wallet != nil  {
        
            self.latestTransaction = transaction
            self.latestTransactionWallet = wallet
            self.saveLatestTransaction()
            NotificationCenter.default.post(name: .didReceiveData, object: nil)
        }
    }
    
    public func getPortfolioTotalValue() -> String {
        
        var total = 0.0
        let xeExchange = Double(XEExchangeRatesManager.shared.getRates()?.rate ?? 0)
        let etherExchange = Double(EtherExchangeRatesManager.shared.getRateValue())
        
        for wallet in self.walletData {

            if wallet.type == .xe {
                
                if let xeBal = wallet.status?.balance {
                
                    total += xeBal * xeExchange
                }
            } else {
                
                if let etherBal = wallet.status?.balance {
                
                    total += etherBal * etherExchange
                }
                
                let edgeBalance = wallet.status?.getTokenBalance(type: .edge)
                total += edgeBalance ?? 0.0 * xeExchange
            }
        }

        return "\(StringHelpers.generateValueString(value: total)) USD"
    }
    
    func getAmountOfWalletsForType(type: WalletType) -> Int {
        
        var amount = 0
        for wall in self.walletData {
        
            if wall.type == type {
                
                amount += 1
            }
        }
            
        return amount
    }
    
    func deleteWallet(address: String) {
        
        if let i = self.walletData.firstIndex(where: { $0.address == address }) {
            
            self.walletData.remove(at: i)
        }
        self.saveWalletData()
    }
}
