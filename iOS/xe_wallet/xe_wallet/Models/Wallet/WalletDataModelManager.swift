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

    
    private init() {
        
        self.loadWalletList()
    }
        
    func loadWalletList() {
        
        if let data = UserDefaults.standard.data(forKey: Constants.defaultStorageName) {
            
            self.walletData = try! JSONDecoder().decode([WalletDataModel].self, from: data)
        }
    }
    
    public func saveWalletToSystem(wallet:AddressKeyPairModel, type: WalletType) {
        
        let username = wallet.address
        let password = wallet.privateKey.data(using: .utf8)!//PD.hex().data(using: .utf8)!

        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password,
        ]

        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
                        
            let wallet = WalletDataModel(type: type, address: wallet.address)
            self.walletData.append(wallet)
            self.saveWalletData()
        } else {

        }
    }
    
    private func saveWalletData() {
        
        let wData = try! JSONEncoder().encode(self.walletData)
        //let test = try! JSONDecoder().decode([WalletDataModel].self, from: wData)
        UserDefaults.standard.set(wData, forKey: Constants.defaultStorageName)
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
               let username = existingItem[kSecAttrAccount as String] as? String,
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
            
            wallet.downloadWalletsData()
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
        
// TODO use protocols for wallets with same functionality
    
    public func generateWallet(type:WalletType) -> AddressKeyPairModel? {
        
        switch type {
            
        case .xe:
            let pair = XEWallet().generateWallet(type:type)
            return pair
            
        case .ethereum:
            let pair = EtherWallet().generateWallet(type:type)
            return pair

        case .edge:
            break
        }
        return nil
    }
    
    public func restoreWallet(type:WalletType, key: String) -> AddressKeyPairModel? {
        
        switch type {
            
        case .xe:
            let pair = XEWallet().generateWalletFromPrivateKey(privateKeyString: key)
            return pair
            
        case .ethereum:
            let pair = EtherWallet().generateWalletFromPrivateKey(privateKeyString: key)
            return pair
            
        case .edge:
            break
        }
        return nil
    }
    
    public func sendCoins(wallet: WalletDataModel, toAddress: String, memo: String, amount: String) {
        
        let key = self.loadWalletKey(key:wallet.address)
        
        switch wallet.type {
            
        case .xe:
            XEWallet().sendCoins(wallet: wallet, toAddress: toAddress, memo: memo, amount: amount, key: key)
            break
            
        case .ethereum:
            break
            
        case .edge:
            break
        }
    }
    
    public func exchangeCoins(wallet: WalletDataModel, toAddress: String, amount: String) {
        
        let key = self.loadWalletKey(key:wallet.address)
        
        switch wallet.type {
            
        case .xe:
            XEWallet().withdrawCoins(wallet: wallet, toAddress: toAddress, amount: amount, key: key)
            break
            
        case .ethereum:
            break
            
        case .edge:
            break
        }
    }
}
