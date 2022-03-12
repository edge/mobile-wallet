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
    
    
    public func downloadAllWalletData(addresses: [String], completion: @escaping (XESummaryDataModel?)-> Void) {
        
        let url = WalletType.xe.getDataNetwork(dataType: .summary)
        let joinedAddresses = addresses.joined(separator: ",")
        
        let finalurl = "\(url)\(joinedAddresses)/summary"
        print(finalurl)
        Alamofire.request(finalurl, method: .get, encoding: URLEncoding.queryString, headers: nil)
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

                    let summary = try JSONDecoder().decode(XESummaryDataModel.self, from: response.data!)
                    completion(summary)
                } catch let error as NSError {
                    
                    print("Failed to load: \(String(describing: error))")
                    completion(nil)
                }

                 case .failure(let error):
                    print("Request error: \(String(describing: error))")
                    completion(nil)
             }
         }
    }
    
    func downloadAllTransactions(address: String, page: Int, block: Int, completion: @escaping ([TransactionDataModel]?, Int, Int)-> Void) {
        
        let urlTransactions = WalletType.xe.getDataNetwork(dataType: .transaction)
        //NetworkState. AppDataModelManager.shared.getXEServerTransactionUrl()
        print("\(urlTransactions)\(address)?above=block&page=\(page)")
        Alamofire.request("\(urlTransactions)\(address)?above=\(block)&page=\(page)", method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

            switch (response.result) {

                case .success( _):

                do {

                    var data = try JSONDecoder().decode(XETransactionsDataModel.self, from: response.data!)

                    var transArray:[TransactionDataModel] = []
                    if let results = data.results {
                        
                        for res in results {
                            
                            var trans = TransactionDataModel()
                            
                            trans.timestamp = res.timestamp/1000
                            trans.sender = res.sender
                            trans.recipient = res.recipient
                            trans.amount = Double(res.amount / 1000000)
                            trans.data = TransactionDataDataModel(memo: res.data?.memo ?? "")
                            trans.nonce = res.nonce
                            trans.signature = res.signature
                            trans.hash = res.hash
                            trans.block = TransactionBlockDataModel(height: res.block?.height ?? 0, hash: res.block?.hash ?? "")
                            trans.confirmations = res.confirmations
                            if let stat = res.status {
                                
                                trans.status = stat
                            } else {
                                
                                trans.status = .confirmed
                            }
                            
                            trans.type = .xe
                            transArray.append(trans)
                        }
                    }
                    completion(transArray, data.metadata?.count ?? 0, data.metadata?.totalCount ?? 0)

                } catch let error as NSError {
                    
                    print("Failed to load: \(String(describing: error))")
                    completion(nil,0,0)
                }
                case .failure(let error):
                    print("Request error: \(String(describing: error))")
                    completion(nil,0,0)
             }
         }
    }
    
    
    
    
    
    
    public func downloadStatus(address: String, completion: @escaping (WalletStatusDataModel?)-> Void) {
        
        let url = WalletType.xe.getDataNetwork(dataType: .status)
        
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
                    let newStats = WalletStatusDataModel(address: status.address ?? "", balance: Double(status.balance ?? 0)/1000000, erc20Tokens: nil, nonce: status.nonce ?? 0)
                    
                    completion(newStats)
                    //completion( status)
                    
                } catch let error as NSError {
                    
                    print("Failed to load: \(String(describing: error))")
                    completion(nil)
                }
                
                 case .failure(let error):
                    print("Request error: \(String(describing: error))")
                    completion(nil)
             }
         }
    }
    

    
    func downloadTransactions(address: String, completion: @escaping ([TransactionDataModel]?)-> Void) {
        
        let urlTransactions = WalletType.xe.getDataNetwork(dataType: .transaction)
        //NetworkState. AppDataModelManager.shared.getXEServerTransactionUrl()
                
        Alamofire.request("\(urlTransactions)\(address)", method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

            switch (response.result) {

                case .success( _):

                do {

                    var data = try JSONDecoder().decode(XETransactionsDataModel.self, from: response.data!)

                    var transArray:[TransactionDataModel] = []
                    if let results = data.results {
                        
                        for res in results {
                            
                            var trans = TransactionDataModel()
                            
                            trans.timestamp = res.timestamp/1000
                            trans.sender = res.sender
                            trans.recipient = res.recipient
                            trans.amount = Double(res.amount / 1000000)
                            trans.data = TransactionDataDataModel(memo: res.data?.memo ?? "")
                            trans.nonce = res.nonce
                            trans.signature = res.signature
                            trans.hash = res.hash
                            trans.block = TransactionBlockDataModel(height: res.block?.height ?? 0, hash: res.block?.hash ?? "")
                            trans.confirmations = res.confirmations
                            trans.status = res.status
                            trans.type = .xe
                            transArray.append(trans)
                        }
                    }
                    
                    self.downloadPendingTransactions(address: address, completion: { pending in
                    
                        if let pend = pending {
                        
                            transArray.append(contentsOf: pend)
                        }
                        completion(transArray)
                    })

                } catch let error as NSError {
                    
                    print("Failed to load: \(String(describing: error))")
                }
                case .failure(let error):
                    print("Request error: \(String(describing: error))")
             }
         }
    }
    
    func downloadPendingTransactions(address: String, completion: @escaping ([TransactionDataModel]?)-> Void) {

        let urlPending = WalletType.xe.getDataNetwork(dataType: .pendingTransaction)
        Alamofire.request("\(urlPending)\(address)", method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

             //print(response)
            switch (response.result) {

                case .success( _):

                do {

                    if response.data?.count ?? 0 > 2 {
                    
                        let data = try JSONDecoder().decode([XETransactionPendingRecordDataModel].self, from: response.data!)
                        
                        var transArray:[TransactionDataModel] = []
                        for res in data {
                            
                            var trans = TransactionDataModel()
                            
                            trans.timestamp = res.timestamp/1000
                            trans.sender = res.sender
                            trans.recipient = res.recipient
                            trans.amount = Double(res.amount / 1000000)
                            trans.data = TransactionDataDataModel(memo: res.data?.memo ?? "")
                            trans.nonce = res.nonce
                            trans.signature = res.signature
                            trans.hash = res.hash
                            trans.status = .pending
                            trans.type = .xe
                            transArray.append(trans)
                        }
                        completion(transArray)
                    } else {
                        
                        completion(nil)
                    }
                } catch let error as NSError {
                    
                    print("Failed to load: \(String(describing: error))")
                    completion(nil)
                }

                 case .failure(let error):
                    print("Request error: \(String(describing: error))")
                    completion(nil)
             }
         }
    }
    
    func sendCoins(wallet: WalletDataModel, toAddress: String, memo: String, amount: String, key: String, completion: @escaping (Bool, String)-> Void) {
         
        let amountString = amount.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        let digitalAmount = Int(amountString) ?? 0

        var j2String = "{\"timestamp\":\(UInt64(Date().timeIntervalSince1970)*1000),\"sender\":\"\(wallet.address)\",\"recipient\":\"\(toAddress)\",\"amount\":\(digitalAmount),\"data\":{\"memo\":\"\(memo)\"},\"nonce\":\(wallet.status?.nonce ?? 0)}"
        j2String = j2String.replacingOccurrences(of: "\\", with: "", options: .regularExpression)
        let sig = self.generateSignature(message: j2String, key: key)
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"signature\":\"\(sig)\"}"
        let hash = j2String.sha256()
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"hash\":\"\(hash)\"}"
        
        let url = WalletType.xe.getDataNetwork(dataType: .send)
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: nil, encoding: BodyStringEncoding(body: j2String), headers: headers ).responseJSON { response in
            print(response)
            
            switch (response.result) {
                
            case .success( _):
                
                if let json = response.result.value as? [String:AnyObject] {
                    
                    if let meta : [String:AnyObject] = json["metadata"] as? [String : AnyObject] {
                        
                        var error = ""
                        if let _ = meta["accepted"]  {
                            
                            completion(true, "")
                        }
                        if let _ = meta["rejected"]  {
                            
                            if let results : [AnyObject] = json["results"] as? [AnyObject] {
                                
                                if let errString = results[0]["reason"] {
                                
                                    error = errString as! String
                                }
                            }
                        }
                        completion(true, error)
                    }
                }
                
            case .failure(let error):
                print("Request error: \(String(describing: error))")
                completion(false, "")
            }
        }
    }
    
    func withdrawCoins(wallet: WalletDataModel, toAddress: String, toType: WalletType, amount: String, fee: Double, key: String, completion: @escaping (Bool)-> Void) {
        
        var amountString = amount.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        amountString = amountString.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range:nil)
        let digitalAmount = Int(amountString) ?? 0
        var digitalFee = Int(fee*1000000)
        var ref = ""
        if let rates = XEGasRatesManager.shared.getRates() {
            
            digitalFee = rates.fee
            ref = rates.ref
        }
        if toType == .usdc {
            
            if let rates = XEExchangeRatesManager.shared.getRates() {
                
                ref = rates.ref
            }
        }
        
        var j2String = ""
        if toType == .usdc {
            
            j2String = "{\"timestamp\":\(UInt64(Date().timeIntervalSince1970)*1000),\"sender\":\"\(wallet.address)\",\"recipient\":\"\(AppDataModelManager.shared.getNetworkStatus().getWithdrawBridgeAddress())\",\"amount\":\(digitalAmount),\"data\":{\"destination\":\"\(toAddress)\",\"ref\":\"\(ref)\",\"memo\":\"XE Sale\",\"token\":\"USDC\"},\"nonce\":\(wallet.status?.nonce ?? 0)}"
        } else {
            
            j2String = "{\"timestamp\":\(UInt64(Date().timeIntervalSince1970)*1000),\"sender\":\"\(wallet.address)\",\"recipient\":\"\(AppDataModelManager.shared.getNetworkStatus().getWithdrawBridgeAddress())\",\"amount\":\(digitalAmount),\"data\":{\"destination\":\"\(toAddress)\",\"ref\":\"\(ref)\",\"memo\":\"XE Withdrawal\",\"token\":\"EDGE\"},\"nonce\":\(wallet.status?.nonce ?? 0)}"
        }
        j2String = j2String.replacingOccurrences(of: "\\", with: "", options: .regularExpression)
        let sig = self.generateSignature(message: j2String, key: key)
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"signature\":\"\(sig)\"}"
        let hash = j2String.sha256()
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"hash\":\"\(hash)\"}"
        
        let url = WalletType.xe.getDataNetwork(dataType: .send)
        
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
                print("Request error: \(String(describing: error))")
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
