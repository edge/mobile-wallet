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


struct BodyStringEncoding: ParameterEncoding {

    private let body: String

    init(body: String) { self.body = body }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
        urlRequest.httpBody = data
        return urlRequest
    }
}

extension BodyStringEncoding {
    enum Errors: Error {
        case emptyURLRequest
        case encodingProblem
    }
}

extension BodyStringEncoding.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .emptyURLRequest: return "Empty url request"
            case .encodingProblem: return "Encoding problem"
        }
    }
}


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

             print(response)
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
    
    func sendCoins(wallet: WalletDataModel, toAddress: String, memo: String, amount: String, key: String, completion: @escaping (Bool)-> Void) {
                
        do {

            let amountString = amount.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
            let digitalAmount = Int(amountString) ?? 0
            let data = SendMessageDataModel(memo: "Testing")
            let sendMessage = SendMessageModel(timestamp: UInt64(Date().timeIntervalSince1970)*1000, sender: wallet.address, recipient: toAddress, amount: digitalAmount, data: data, nonce: wallet.status?.nonce ?? 0)
            
            var j2String = "{\"timestamp\":\(UInt64(Date().timeIntervalSince1970)*1000),\"sender\":\"\(wallet.address)\",\"recipient\":\"\(toAddress)\",\"amount\":\(digitalAmount),\"data\":{\"memo\":\"Testing\"},\"nonce\":\(wallet.status?.nonce ?? 0)}"
            j2String = j2String.replacingOccurrences(of: "\\", with: "", options: .regularExpression)
            let sig = self.generateSignature(message: j2String, key: key)
            j2String = String(j2String.dropLast())
            j2String = "\(j2String),\"signature\":\"\(sig)\"}"
            let hash = j2String.sha256()
            j2String = String(j2String.dropLast())
            j2String = "\(j2String),\"hash\":\"\(hash)\"}"
            
            let url = AppDataModelManager.shared.getXEServerSendUrl()
            
            let headers: HTTPHeaders = [
                "Content-type": "application/json"
            ]
            Alamofire.request(url, method: .post, parameters: nil, encoding: BodyStringEncoding(body: j2String), headers: headers ).responseJSON { response in
                 print(response)

                switch (response.result) {

                    case .success( _):

                    if let json = response.result.value as? [String:AnyObject] {
                        
                        if let meta : [String:AnyObject] = json["metadata"] as? [String : AnyObject] {
                            
                            if let accepted = meta["accepted"]  {
                                
                                completion(true)
                            }
                            if let rejected = meta["rejected"]  {
                               
                                completion(false)
                            }
                        }
                        

                    }
                    
                     case .failure(let error):
                        print("Request error: \(error.localizedDescription)")
                        completion(false)
                 }
            }
            
        } catch _ {
            print ("JSON Failure")
        }
    
    }
    
    func withdrawCoins(wallet: WalletDataModel, toAddress: String, amount: String, key: String) {
        
        do {
            /*"timestamp": 1637568556235,
            "sender": "xe_8eC0B0fE40142adE4a1Be2c67810210c596398ee",
            "recipient": "xe_A4788d8201Fb879e3b7523a0367401D2a985D42F",
            "amount": 35064000000,
            "data": {
              "destination": "0x839667153D52aA712C276d30386628678C61c880",
              "fee": 319000000,
              "memo": "XE Withdrawal",
              "token": "EDGE"
            },
            "nonce": 18,*/
            
            
            
            let amountString = amount.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
            let digitalAmount = Int(amountString) ?? 0
            let data = SendMessageDataModel(memo: "Testing")
            let sendMessage = SendMessageModel(timestamp: UInt64(Date().timeIntervalSince1970)*1000, sender: wallet.address, recipient: toAddress, amount: digitalAmount, data: data, nonce: wallet.status?.nonce ?? 0)
            
            var j2String = "{\"timestamp\":\(UInt64(Date().timeIntervalSince1970)*1000),\"sender\":\"\(wallet.address)\",\"recipient\":\"xe_A4788d8201Fb879e3b7523a0367401D2a985D42F\",\"amount\":\(digitalAmount),\"data\":{\"destination\":\"\(toAddress)\",\"fee\":\(1000000),\"memo\":\"XE Withdrawal\",\"token\":\"EDGE\"},\"nonce\":\(wallet.status?.nonce ?? 0)}"
            print(j2String)
            j2String = j2String.replacingOccurrences(of: "\\", with: "", options: .regularExpression)
            print(j2String)
            var sig = self.generateSignature(message: j2String, key: key)
            print(sig)
            j2String = String(j2String.dropLast())
            print(j2String)
            j2String = "\(j2String),\"signature\":\"\(sig)\"}"
            print(j2String)
            var hash = j2String.sha256()
            print(hash)
            j2String = String(j2String.dropLast())
            print(j2String)
            j2String = "\(j2String),\"hash\":\"\(hash)\"}"
            print(j2String)
            
            let url = AppDataModelManager.shared.getXEServerSendUrl()
            
            let headers: HTTPHeaders = [
                "Content-type": "application/json"
            ]
            Alamofire.request(url, method: .post, parameters: nil, encoding: BodyStringEncoding(body: j2String), headers: headers ).responseJSON { response in
                 print(response)
                    print(NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue))
            }
        } catch _ {
            print ("JSON Failure")
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
