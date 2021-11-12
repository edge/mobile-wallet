//
//  XEWallet.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/11/2021.
//

import SwiftKeccak
import UIKit
import Security

class XEWallet {
    
    public func generateWallet(type:WalletType) -> AddressKeyPairModel {
                
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
