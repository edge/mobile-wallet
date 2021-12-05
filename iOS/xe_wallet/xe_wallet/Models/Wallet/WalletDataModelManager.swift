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
    
    private init() {
        
        self.loadWalletList()
        self.timerUpdate = Timer.scheduledTimer(withTimeInterval: Constants.UpdateWalletsTimer, repeats: true) { timer in
            
            self.reloadAllWalletInformation()
        }
    }
        
    func loadWalletList() {
        
        if let data = UserDefaults.standard.data(forKey: Constants.defaultStorageName) {
            
            self.walletData = try! JSONDecoder().decode([WalletDataModel].self, from: data)
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
        /*
        do {
            
            let password = try KeychainHelper.update(account: username)
            return password
        } catch {
        }*/
        
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
        } else {
        }
        return ""
    }
    
    public func reloadAllWalletInformation() {
        
        for wallet in self.walletData {
            
            wallet.downloadWalletStatus()
            wallet.downloadWalletTransactions()
        }
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
        
}
