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
import Alamofire
//import Web3
import BigInt
import SwiftyJSON

struct Wallet {
    let address: String
    let data: Data
    let name: String
    let isHD: Bool
}

class EtherWallet {
    
    public func generateWallet(type:WalletType) -> AddressKeyPairModel {
                
        let password = AppDataModelManager.shared.getAppPinCode()
        let keystore = try! EthereumKeystoreV3(password: password)!
        //let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        
        let ethereumAddress = EthereumAddress(address)!
        let pkData = try! keystore.UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress).toHexString()
        
        return  AddressKeyPairModel(privateKey: pkData , address: address)
    }
    
    public func generateWalletFromPrivateKey(privateKeyString: String) -> AddressKeyPairModel {
        
        let password = AppDataModelManager.shared.getAppPinCode()
        let formattedKey = privateKeyString.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        let address = keystore.addresses!.first!.address
                
        return AddressKeyPairModel(privateKey: privateKeyString, address: address)
    }
    
    public func downloadStatus(address: String, completion: @escaping (EtherWalletStatusDataModel?)-> Void) {

        var web3 = Web3.InfuraMainnetWeb3()
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3()
        }
        let walletAddress = EthereumAddress(address)!
        let balanceResult = try! web3.eth.getBalance(address: walletAddress)
        var bs = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 6)!
        bs = bs.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        
        //self.downloadEdgeStatus(address: address)
        
        completion(EtherWalletStatusDataModel(address: address, balance:Double(bs) ?? 0, nonce:0, edgeBalance: 0))
    }
    
    func downloadEdgeStatus(address: String) {
        
        var web3 = Web3.InfuraMainnetWeb3()
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3()
        }

        let walletAddress = EthereumAddress(address)! // Your wallet address
        let exploredAddress = EthereumAddress(address)! // Address which balance we want to know. Here we used same wallet address
        let erc20ContractAddress = EthereumAddress("0xbf57cd6638fdfd7c4fa4c10390052f7ab3a1c301")!
        let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let method = "balanceOf"
        let tx = contract.read(
            method,
            parameters: [exploredAddress] as [AnyObject],
            extraData: Data(),
            transactionOptions: options)!
        let tokenBalance = try! tx.call()
        
        if let token = tokenBalance["0"] {
            
            let big = BigUInt.init("\(token)", Web3.Utils.Units.wei)!
            
            //var test = web3.Utils. .Convert.FromWei()
            
            var bs = Web3.Utils.formatToEthereumUnits(big, toUnits: .eth, decimals: 6)!
            let result = Web3.Utils.formatToPrecision(big, numberDecimals: 0, formattingDecimals: 6, decimalSeparator: ".", fallbackToScientific: false)
            
            if let resString = result {
                if let t2 = Int(resString) {
                
                    print("\(t2/100000000)")
                }
            }

            let result2 = Web3.Utils.formatToEthereumUnits(big)
            print(result)
            //var bs = Web3.Utils.formatToEthereumUnits(big, toUnits: .Finney, decimals: 6)!
            //print(bs)
        }
        
        //let result = Web3.Utils.formatToPrecision(big, numberDecimals: decimals, formattingDecimals: 8, decimalSeparator: ".", fallbackToScientific: false)
        //print(result)  // Optional("0.300000")
        //if Float(balanceWithSymbol) == Float(result as! String) {
        //     print("right")
        //} else {
        //     print("wrong")
       // }
    }
    
    func downloadTransactions(address: String, completion: @escaping (TransactionsDataModel)-> Void) {
        
        let apiUrl = "https://api-rinkeby.etherscan.io/api?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=10&sort=asc"
        let apiKey = "2HA3ZV1XH4JHEVRA7J534AJ1PUGQVVKD4V"
        let url = "\(apiUrl)&address=\(address)&apikey=\(apiKey)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            switch (response.result) {

                case .success( _):

                do {
                    
                    let data = try JSONDecoder().decode(EtherTransactionsDataModel.self, from: response.data!)
                    let transModel = TransactionsDataModel(from: data)
                    completion(transModel)
                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                }
                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
             }
        }
    }
    
    public func sendEther(toAddr: String, fromAddr: String, amt: String, parent: UIViewController) {
        
        /*DispatchQueue.global().async {
            
            let value: String = amt
            let walletAddress = EthereumAddress(fromAddr)! // Your wallet address
            let toAddress = EthereumAddress(toAddr)!
            
            guard let web3 = self.web3Rinkeby else { return }
            let contract = web3.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
            let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
            var options = TransactionOptions.defaultOptions
            options.value = amount
            options.from = walletAddress
            options.gasPrice = .automatic
            options.gasLimit = .automatic
            let tx = contract.write(
                "fallback",
                parameters:  [AnyObject](),
                extraData: Data(),
                transactionOptions: options)!
            
            
            guard let pass = WalletModelManager.shared.getCode() else { return }
            do {
                let sendResultBip32 = try tx.send(password: pass)
                print(sendResultBip32)
                
            } catch {
                print(error)
            }
        }*/
    }
    
    func depositCoins(wallet: WalletDataModel, toAddress: String, amount: String, key: String, completion: @escaping (Bool)-> Void) {
        
        let amountString = amount.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        /*let digitalAmount = Int(amountString) ?? 0
        
        var j2String = "{\"timestamp\":\(UInt64(Date().timeIntervalSince1970)*1000),\"sender\":\"\(wallet.address)\",\"recipient\":\"xe_A4788d8201Fb879e3b7523a0367401D2a985D42F\",\"amount\":\(digitalAmount),\"data\":{\"destination\":\"\(toAddress)\",\"fee\":\(1000000),\"memo\":\"XE Withdrawal\",\"token\":\"EDGE\"},\"nonce\":\(wallet.status?.nonce ?? 0)}"
        j2String = j2String.replacingOccurrences(of: "\\", with: "", options: .regularExpression)
        let sig = self.generateSignature(message: j2String, key: key)
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"signature\":\"\(sig)\"}"
        let hash = j2String.sha256()
        j2String = String(j2String.dropLast())
        j2String = "\(j2String),\"hash\":\"\(hash)\"}"*/
        
        
        var web3 = Web3.InfuraMainnetWeb3()
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3()
        }

        let abiContract = self.getDepositABIContract(completion: { abiJson in
        
            print(abiJson)
            
            let value: String = "0" // Any amount of Ether you need to send
            let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
            let contractMethod = "approveAndCall" // Contract method you want to write
            let contractABI = abiJson
            let contractAddress = EthereumAddress(AppDataModelManager.shared.getNetworkStatus().getDepositTokenAddress())!
            let abiVersion = 2 // Contract ABI version
            let amount = Web3.Utils.parseToBigUInt(amountString, units: .eth)
            let parameters: [Any] = ["_sender", walletAddress, "_amount",amount, "_destination",toAddress] // Parameters for contract method
            let extraData: Data = Data() // Extra data for contract method
            let contract = web3.contract(contractABI ?? "", at: contractAddress, abiVersion: abiVersion)!
            var options = TransactionOptions.defaultOptions
            options.value = Web3.Utils.parseToBigUInt(value, units: .eth)
            options.from = walletAddress
            //options.to = contractAddress
            options.gasPrice = .automatic
            options.gasLimit = .automatic
            let txMessage = contract.write(
                contractMethod,
                parameters:  parameters as [AnyObject],
                extraData: extraData,
                transactionOptions: options)
            
            if let tx = txMessage {
            
                let test = try! tx.call()

                print(tx)
            }
        })
        
        
        /*
        let value: String = amountString // Any amount of Ether you need to send
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        let contractMethod = "SOMECONTRACTMETHOD" // Contract method you want to write
        let contractABI = "..." // Contract ABI
        let contractAddress = EthereumAddress(AppDataModelManager.shared.getNetworkStatus().getDepositBridgeAddress())!
        let abiVersion = 2 // Contract ABI version
        let parameters: [AnyObject] = [...]() // Parameters for contract method
        let extraData: Data = Data() // Extra data for contract method
        let contract = web3.contract(contractABI, at: contractAddress, abiVersion: abiVersion)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let tx = contract.write(
            contractMethod,
            parameters: parameters,
            extraData: extraData,
            transactionOptions: options)!*/
    }
    
    func getDepositABIContract(completion: @escaping (String?)-> Void) {
        
        let url = AppDataModelManager.shared.getNetworkStatus().getABIContactUrl()
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

             print(response)
            switch (response.result) {

                case .success( _):

                if let result = response.result.value {
                    
                    let JSON = result as! NSDictionary
                    let abi = JSON["abi"]
                    print(abi)
                    
                    //let paramsJSON = JSON(abi)
                    //let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
                    
                    let jsonString = self.json(from: abi)
                    completion(jsonString)
                }
                
                /*if let json = response.result.value as? [String:AnyObject] {
                    
                    if let abi : [String:AnyObject] = json["abi"] as? [String : AnyObject] {
                        
                        let json = String(data: abi, encoding: NSUTF8StringEncoding)
                        print(json)
                        completion(json)
                    }
                }*/
                completion(nil)

                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                    completion(nil)
             }
         }
    }
                               
    func json(from object:Any) -> String? {
                        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

