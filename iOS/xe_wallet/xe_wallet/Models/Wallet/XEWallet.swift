//
//  XEWallet.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/11/2021.
//

import SwiftKeccak
import UIKit
import Security
import Alamofire
import CryptoSwift
import secp256k1

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
        
        return AddressKeyPairModel(privateKey: privateKeyData.hex(), address: address)//PD
    }
    
    public func generateWalletFromPrivateKey(privateKeyString: String) -> AddressKeyPairModel {
        
        let context = Secp256k1Context()
        let privateKeyData = Secp256k1PrivateKey(privKey: privateKeyString.toBytes)
        
        let publicKeyData = try! context.getPublicKey(privateKey: privateKeyData)
        let publicKeyString = publicKeyData.hex()
        print("PUBLIC KEY : \(publicKeyString)")
        
        let address = self.publicKeyToChecksumAddress(publicKey: publicKeyString)
        print("ADDRESS : \(address)")
        
        return AddressKeyPairModel(privateKey: privateKeyData.hex(), address: address)//PD
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
    
    public func downloadStatus(address: String, completion: @escaping (WalletStatusDataModel)-> Void) {

        
        let url = AppDataModelManager.shared.getXEServerStatusUrl()
        
        Alamofire.request("\(url)\(address)", method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

             guard response.result.error == nil else {
                 print("error calling GET ")
                 print(response.result.error!)
                 return
             }
             
            switch (response.result) {

                case .success( _):

                do {

                    let data = try JSONDecoder().decode(WalletStatusDataModel.self, from: response.data!)
                    completion(data)

                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }

                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
             }
         }
    }
    
    func downloadTransactions(address: String, completion: @escaping (TransactionsDataModel)-> Void) {
        
        let url = AppDataModelManager.shared.getXEServerTransactionUrl()
        
        Alamofire.request("\(url)\(address)", method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

            switch (response.result) {

                case .success( _):

                do {

                    let data = try JSONDecoder().decode(TransactionsDataModel.self, from: response.data!)
                    completion(data)

                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }

                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
             }
         }
    }
    
    func sendCoins(wallet: WalletDataModel, toAddress: String, memo: String, amount: String, key: String) {
                
        let amountString = amount.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        let digitalAmount = Int(amountString)
        
        var jsonObject: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "sender": wallet.address,
            "recipient": toAddress,
            "amount": digitalAmount,
            "data": [
                "memo": memo
            ],
            "nonce": wallet.status?.nonce
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
            print (jsonString)
            let sig = self.generateSignature(message: jsonString, key: key)
            jsonObject.updateValue(sig, forKey: "signature")
            
            
            
        } catch _ {
            print ("JSON Failure")
        }
    
    }
    
    func generateSignature(message: String, key: String) -> String {
        
        //let msgHash = "hello world".sha256() //message.sha256()
        //let addrHash = keccak256(msgHash).toHexString()
        
        let addrHashArray: [UInt8] = Array(message.utf8)
        //let addrHashArray: [UInt8] = Array("hello world".utf8)
        let context = Secp256k1Context()
        let privateKey = Secp256k1PrivateKey(privKey: key.toBytes)
        //let privateKey = Secp256k1PrivateKey(privKey: "d221434e2cf538ca8dd409e6ccea0d9b75d7c8eb3efa10a507cf8277d786d5ac".toBytes)
        
        //let signatureObj1 = try! context.sign(data: addrHashArray, privateKey: privateKey)
        let signatureObj = try! context.sign_recoverable(data: addrHashArray, privateKey: privateKey)

        return signatureObj
    }
}
