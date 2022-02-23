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

    var timerUpdate: Timer?
    //var selectedWalletAddress = ""
    
    
    private init() {
        
        self.loadWalletList()
        self.timerUpdate = Timer.scheduledTimer(withTimeInterval: Constants.UpdateWalletsTimer, repeats: true) { timer in
            
            self.reloadAllWalletInformation()
        }
    }
        
    func loadWalletList() {
        
        if let data = UserDefaults.standard.data(forKey: Constants.defaultStorageName) {
            
            self.walletData = try! JSONDecoder().decode([WalletDataModel].self, from: data)
            
            if self.walletData.count > 0 {
                
                //self.selectedWalletAddress = self.walletData[0].address
            }
        }
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
    
    private func saveWalletData() {
        
        let wData = try! JSONEncoder().encode(self.walletData)
        //let test = try! JSONDecoder().decode([WalletDataModel].self, from: wData)
        UserDefaults.standard.set(wData, forKey: Constants.defaultStorageName)
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
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
    
    public func reloadAllWalletInformation() {
        
        for wallet in self.walletData {
            
            wallet.downloadWalletStatus()
            wallet.downloadWalletTransactions()
        }
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
        
    public func getLatestTransaction() -> (transaction: TransactionRecordDataModel?, wallet: WalletDataModel?) {
            
        var transaction: TransactionRecordDataModel? = nil
        var wallet: WalletDataModel? = nil
        
        if self.walletData.count == 0 {
            
            return (nil, nil)
        }
        
        for wall in self.walletData {
            
            if let transactions = wall.transactions {
                
                if let res = transactions.results {
                    
                    for trans in res {
                    
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
        }
            
        return (transaction, wallet)
    }
    
    public func getWalletTotalValue() -> String {
        
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
                
                if let edgeBal = wallet.status?.edgeBalance {
                
                    total += edgeBal * xeExchange
                }
            }
        }

        return "\(StringHelpers.generateValueString(value: total)) USD"
    }
    
    func getXEWalletAmount() -> Int {
        
        var amount = 0
        for wall in self.walletData {
        
            if wall.type == .xe {
                
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
