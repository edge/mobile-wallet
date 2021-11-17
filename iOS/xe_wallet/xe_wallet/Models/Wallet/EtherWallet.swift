//
//  EtherWallet.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/11/2021.
//

import SwiftKeccak
import UIKit
import Security
import web3swift
import secp256k1

class EtherWallet {
    
    public func generateWallet(type:WalletType) -> AddressKeyPairModel {
                
        let password = "web3swift" // We recommend here and everywhere to use the password set by the user.
        let keystore = try! EthereumKeystoreV3(password: password)!
        let name = "New Wallet"
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        //let wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
        
        let ethereumAddress = EthereumAddress(address)!
        let pkData = try! keystore.UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress).toHexString()
        
        return  AddressKeyPairModel(privateKey: "" as! PrivateKey , address: "")
    }
    
}

