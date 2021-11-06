//
//  WalletDataModelManager.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation
import secp256k1
import SwiftKeccak
import keccak256
import UIKit
import Security

class WalletDataModelManager {

    static let shared = WalletDataModelManager()
    
    var walletData = [WalletDataModel]()
    
    var walletAddressList:[String] = []
    
    private init() {
        
        //UserDefaults.standard.removeObject(forKey: "WalletList")
        self.walletAddressList = UserDefaults.standard.stringArray(forKey: "WalletList") ?? [String]()
        self.buildWalletDatabase()

        /*self.walletData.append(WalletDataModel(type:.xe, backedup: false, address: "xe_A4788d8201Fb879e3b7523a0367401D2a985D42F", transactions: [
            TransactionRecordDataModel(type:.receive, status:.pending, date:"test", amount:"12.000000"),
            TransactionRecordDataModel(type:.send, status:.confirmed, date:"test", amount:"9.001000"),
            TransactionRecordDataModel(type:.exchange, status:.confirmed, date:"test", amount:"4.120000")
                                               ]))
        self.walletData.append(WalletDataModel(type:.edge, backedup: false, address: "skfjhasdkjfhasdfkjhasdfjkhasdf", transactions: [
            TransactionRecordDataModel(type:.receive, status:.confirmed, date:"test", amount:"5.110000")
                                               ]))
        self.walletData.append(WalletDataModel(type:.xe, backedup: false, address: "xe_A1188d8201Fb879e3b7523a0367401D2a985A32C", transactions: [
            TransactionRecordDataModel(type:.receive, status:.pending, date:"test", amount:"3.200000"),
            TransactionRecordDataModel(type:.receive, status:.confirmed, date:"test", amount:"1.000000")
                                               ]))
        self.walletData.append(WalletDataModel(type:.ethereum, backedup: true, address: "asdflkjasdflkjasdflkjasdflkjasdflkj", transactions: [
                                               ]))*/
    }
    
    func buildWalletDatabase() {
        
        self.walletData.removeAll()
        for addr in walletAddressList {
            
            self.walletData.append(WalletDataModel(type: .xe, address: addr, transactions: [
                TransactionRecordDataModel(type:.receive, status:.pending, date:"test", amount:"12.000000"),
                TransactionRecordDataModel(type:.send, status:.confirmed, date:"test", amount:"9.001000"),
                TransactionRecordDataModel(type:.exchange, status:.confirmed, date:"test", amount:"4.120000")
                                                   ]))
        }
    }
    
    public func saveWalletToSystem(wallet:AddressKeyPairModel) {
        
        let username = wallet.address
        let password = wallet.privateKey.hex().data(using: .utf8)!

        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password,
        ]

        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            
            self.walletAddressList.append(wallet.address)
            UserDefaults.standard.set(self.walletAddressList, forKey: "WalletList")
            self.buildWalletDatabase()
        } else {

        }
    }
    
    public func activeWalletAmount() -> Int {
        
        //return self.walletAddressList.count
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
               let password = String(data: passwordData, encoding: .utf8)
            {

                let a = 1
            }
        } else {

            let b = 2
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
        
    public func generateWallet() -> AddressKeyPairModel {
        
        let context = Secp256k1Context()

        let privateKeyData = context.newRandomPrivateKey()
        let privateKeyString = privateKeyData.hex()
        print("PRIVATE KEY : \(privateKeyString)")
        
        let publicKeyData = try! context.getPublicKey(privateKey: privateKeyData)
        let publicKeyString = publicKeyData.hex()
        print("PUBLIC KEY : \(publicKeyString)")
        
        let address = self.publicKeyToChecksumAddress(publicKey: publicKeyString)
        print("ADDRESS : \(address)")
        
        return AddressKeyPairModel(privateKey: privateKeyData, address: address)
    }
    
    public func publicKeyToChecksumAddress(publicKey: String) -> String {

        let hash = keccak256(publicKey)
        let addr = "\(hash.toHex().substring(with: hash.toHex().count-40..<hash.toHex().count))"
        let addrHash = keccak256(addr.lowercased()).toHex()
        var chkAddr = ""

        for i in 0..<addr.count {
            
            let digit = addrHash[addrHash.index(addrHash.startIndex, offsetBy: i)]
                
            if digit.hexDigitValue! >= 8 {
                    
                chkAddr.append(addr[addr.index(addr.startIndex, offsetBy: i)].uppercased())
            } else {
                
                chkAddr.append(addr[addr.index(addr.startIndex, offsetBy: i)])
            }
        }
        return "xe_\(chkAddr)"
    }
}
