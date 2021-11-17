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
        
        if let data = UserDefaults.standard.data(forKey: "WalletData8") {
            
            self.walletData = try! JSONDecoder().decode([WalletDataModel].self, from: data)
        }
    }
    
    public func saveWalletToSystem(wallet:AddressKeyPairModel, type: WalletType) {
        
        let username = wallet.address
        let password = wallet.privateKey.hex().data(using: .utf8)!

        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password,
        ]

        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
                        
            let wallet = WalletDataModel(type: type, address: wallet.address)
            self.walletData.append(wallet)
            let wData = try! JSONEncoder().encode(self.walletData)
            let test = try! JSONDecoder().decode([WalletDataModel].self, from: wData)
            UserDefaults.standard.set(wData, forKey: "WalletData8")
        } else {

        }
    }
    
    public func activeWalletAmount() -> Int {
        
        return self.walletData.count
    }
    
    public func getWalletData() -> [WalletDataModel] {
        
        return self.walletData
    }
    
    public func loadWalletKey(key:String) {
        
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
            }
        } else {
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
    }
        
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
            let pair = EtherWallet().generateWallet(type:type)
            return pair
            
        case .edge:
            break
        }
        return nil
    }
}
