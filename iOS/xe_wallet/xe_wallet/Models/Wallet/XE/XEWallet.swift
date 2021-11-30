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
import SwiftyJSON

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
        
        return AddressKeyPairModel(privateKey: privateKeyData.hex(), address: address)
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
    
    public func downloadStatus(address: String, completion: @escaping (XEWalletStatusDataModel?)-> Void) {
        
        let url = AppDataModelManager.shared.getNetworkStatus().getStatusUrl()
        
        Alamofire.request("\(url)\(address)", method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

             guard response.result.error == nil else {
                 print("error calling GET ")
                 print(response.result.error!)
                 completion(nil)
                 return
             }
             
            switch (response.result) {

                case .success( _):

                do {

                    let status = try JSONDecoder().decode(XEWalletStatusDataModel.self, from: response.data!)
                    completion( status)
                    
                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                    completion(nil)
                }

                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                    completion(nil)
             }
         }
    }
    

    
    func downloadTransactions(address: String, completion: @escaping (XETransactionsDataModel?)-> Void) {
        
        let urlTransactions = AppDataModelManager.shared.getNetworkStatus().getTransactionsUrl()
        //NetworkState. AppDataModelManager.shared.getXEServerTransactionUrl()
                
        Alamofire.request("\(urlTransactions)\(address)", method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

             //print(response)
            switch (response.result) {

                case .success( _):

                do {

                    var data = try JSONDecoder().decode(XETransactionsDataModel.self, from: response.data!)
                    completion(data)
/*                    var transactions = data.results
                    if transactions == nil {
                        
                        transactions = [XETransactionRecordDataModel]()
                    }
                    var newTrans = [XETransactionRecordDataModel]()
                    self.downloadPendingTransactions(address: address, completion: { pending in
                        
                        if let array = pending {
                            
                            for n in array {
                                
                                let newRecord = TransactionPendingRecordDataModel(from: n)
                                newTrans.insert(newRecord, at: 0)
                            }
                        }
                        data.results = transactions
                        completion(data)
                    })*/


                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                }
                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
             }
         }
    }
    
    func downloadPendingTransactions(address: String, completion: @escaping ([XETransactionPendingRecordDataModel]?)-> Void) {

        let urlPending = AppDataModelManager.shared.getNetworkStatus().getPendingUrl()// .getXEServerPendingUrl()
        Alamofire.request("\(urlPending)\(address)", method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

             //print(response)
            switch (response.result) {

                case .success( _):

                do {

                    if response.data?.count ?? 0 > 2 {
                    
                        let data = try JSONDecoder().decode([XETransactionPendingRecordDataModel].self, from: response.data!)
                        completion(data)
                    } else {
                        
                        completion(nil)
                    }
                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                    completion(nil)
                }

                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                    completion(nil)
             }
         }
    }
    
    func sendCoins(wallet: WalletDataModel, toAddress: String, memo: String, amount: String, key: String, completion: @escaping (Bool)-> Void) {
         
        let amountString = amount.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        let digitalAmount = Int(amountString) ?? 0

        var j2String = "{\"timestamp\":\(UInt64(Date().timeIntervalSince1970)*1000),\"sender\":\"\(wallet.address)\",\"recipient\":\"\(toAddress)\",\"amount\":\(digitalAmount),\"data\":{\"memo\":\"Testing\"},\"nonce\":\(wallet.status?.nonce ?? 0)}"
        j2String = j2String.replacingOccurrences(of: "\\", with: "", options: .regularExpression)
        let sig = self.generateSignature(message: j2String, key: key)
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"signature\":\"\(sig)\"}"
        let hash = j2String.sha256()
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"hash\":\"\(hash)\"}"
        
        let url = AppDataModelManager.shared.getNetworkStatus().getSendUrl()// getXEServerSendUrl()
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: nil, encoding: BodyStringEncoding(body: j2String), headers: headers ).responseJSON { response in
            print(response)
            
            switch (response.result) {
                
            case .success( _):
                
                if let json = response.result.value as? [String:AnyObject] {
                    
                    if let meta : [String:AnyObject] = json["metadata"] as? [String : AnyObject] {
                        
                        if let _ = meta["accepted"]  {
                            
                            completion(true)
                        }
                        if let _ = meta["rejected"]  {
                            
                            completion(false)
                        }
                    }
                }
                
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func withdrawCoins(wallet: WalletDataModel, toAddress: String, amount: String, fee: Double, key: String, completion: @escaping (Bool)-> Void) {
        
        let amountString = amount.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        let digitalAmount = Int(amountString) ?? 0
        let digitalFee = Int(fee*1000000)
        
        var j2String = "{\"timestamp\":\(UInt64(Date().timeIntervalSince1970)*1000),\"sender\":\"\(wallet.address)\",\"recipient\":\"\(AppDataModelManager.shared.getNetworkStatus().getWithdrawBridgeAddress())\",\"amount\":\(digitalAmount),\"data\":{\"destination\":\"\(toAddress)\",\"fee\":\(digitalFee),\"memo\":\"XE Withdrawal\",\"token\":\"EDGE\"},\"nonce\":\(wallet.status?.nonce ?? 0)}"
        j2String = j2String.replacingOccurrences(of: "\\", with: "", options: .regularExpression)
        let sig = self.generateSignature(message: j2String, key: key)
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"signature\":\"\(sig)\"}"
        let hash = j2String.sha256()
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"hash\":\"\(hash)\"}"
        
        let url = AppDataModelManager.shared.getNetworkStatus().getSendUrl()// getXEServerSendUrl()
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: nil, encoding: BodyStringEncoding(body: j2String), headers: headers ).responseJSON { response in
            print(response)
            
            switch (response.result) {
                
            case .success( _):
                
                if let json = response.result.value as? [String:AnyObject] {
                    
                    if let meta : [String:AnyObject] = json["metadata"] as? [String : AnyObject] {
                        
                        if let _ = meta["accepted"]  {
                            
                            completion(true)
                        }
                        if let _ = meta["rejected"]  {
                            
                            completion(false)
                        }
                    }
                }
                
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
        
    func generateSignature(message: String, key: String) -> String {
        
        let addrHashArray: [UInt8] = Array(message.utf8)
        let context = Secp256k1Context()
        print(key)
        let privateKey = Secp256k1PrivateKey(privKey: key.toBytes)
        let signatureObj = try! context.sign_recoverable(data: addrHashArray, privateKey: privateKey)

        return signatureObj
    }
}
