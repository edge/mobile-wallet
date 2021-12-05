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
import PromiseKit
import secp256k1
import Alamofire
//import Web3
import BigInt
import SwiftyJSON
import UInt256

class EtherWallet {
    
    public func generateWallet(type:WalletType) -> AddressKeyPairModel {
                        
        /*let password = AppDataModelManager.shared.getAppPinCode()
        let keystore = try! EthereumKeystoreV3(password: password)!
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        
        let ethereumAddress = EthereumAddress(address)!
        let pkData = try! keystore.UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress).toHexString()
        */
        
        let password = AppDataModelManager.shared.getAppPinCode()
        let keystore = try! EthereumKeystoreV3(password:password)!
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        let ethereumAddress = EthereumAddress(address)!
        let pkData = try! keystore.UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress).toHexString()
        let wallet = Wallet(address: address, data: keyData, name: "", isHD: false)

        return  AddressKeyPairModel(privateKey: pkData , address: address, wallet: wallet)
    }
    
    public func generateWalletFromPrivateKey(privateKeyString: String) -> AddressKeyPairModel {
        
       /* let password = AppDataModelManager.shared.getAppPinCode()
        let formattedKey = privateKeyString.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        let address = keystore.addresses!.first!.address
                
        return AddressKeyPairModel(privateKey: privateKeyString, address: address, wallet: wallet)
        */
        
        let password = AppDataModelManager.shared.getAppPinCode()
        let formattedKey = privateKeyString.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keyStore = try! EthereumKeystoreV3(privateKey:dataKey, password: password)!
        let keyData = try! JSONEncoder().encode(keyStore.keystoreParams)
        let address = keyStore.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: "", isHD: false)
        return AddressKeyPairModel(privateKey: privateKeyString, address: address, wallet: wallet)
    }
    
    public func downloadStatus(address: String, completion: @escaping (EtherWalletStatusDataModel?)-> Void) {

        var web3 = Web3.InfuraMainnetWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
        }

        let walletAddress = EthereumAddress(address)!
        let balanceResult = try! web3.eth.getBalance(address: walletAddress)
        var bs = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 6)!

        let network = AppDataModelManager.shared.getNetworkStatus()

        let exploredAddress = EthereumAddress(address)!
        let erc20ContractAddress = EthereumAddress(network.getDepositTokenAddress())!
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
       
        DispatchQueue.global().async {
        
            let tokenBalance = try! tx.call()
        
            var edgeBalance = "0.0"
            if let token = tokenBalance["0"] {
                
                let big = BigUInt.init("\(token)", Web3.Utils.Units.wei)!
                edgeBalance = Web3.Utils.formatToEthereumUnits(big, toUnits: .eth, decimals: 6)!
            }
            completion(EtherWalletStatusDataModel(address: address, balance:Double(bs) ?? 0, nonce:0, edgeBalance: Double(edgeBalance) ?? 0))
        }
        

    }
    
    func downloadTransactions(address: String, completion: @escaping (EtherTransactionsDataModel?)-> Void) {
        
        let apiUrl = "https://api-rinkeby.etherscan.io/api?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=10&sort=asc"
        let apiKey = "2HA3ZV1XH4JHEVRA7J534AJ1PUGQVVKD4V"
        let url = "\(apiUrl)&address=\(address)&apikey=\(apiKey)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            switch (response.result) {

                case .success( _):

                do {
                                        
                    let data = try JSONDecoder().decode(EtherTransactionsDataModel.self, from: response.data!)
                    //let transModel = TransactionsDataModel(from: data)
                    completion(data)
                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                }
                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
             }
        }
    }
    
    public func sendEther(toAddr: String, wallet: WalletDataModel, amt: String, key: String, completion: @escaping (Bool)-> Void) {
        
        var web3 = Web3.InfuraMainnetWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
        }
        
        guard let ewallet = wallet.wallet else { return }
        let data = ewallet.data
        var keystoreManager: KeystoreManager
        if ewallet.isHD {
            let keystore = BIP32Keystore(data)!
            keystoreManager = KeystoreManager([keystore])
        }else{
            let keystore = EthereumKeystoreV3(data)!
            keystoreManager = KeystoreManager([keystore])
        }
        web3.addKeystoreManager(keystoreManager)
        
        let value: String = amt
        let walletAddress = EthereumAddress(ewallet.address)!
        let toAddress = EthereumAddress(toAddr)!
        let contract = web3.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)

        let response = Promise<Any> { seal in
            
            DispatchQueue.global().async {
                
                do {
                    
                    var options = TransactionOptions.defaultOptions
                    options.value = amount
                    options.from = walletAddress
                    options.gasPrice = .automatic
                    options.gasLimit = .automatic
                    
                    let tx = contract.write(
                    "fallback",
                    parameters: [AnyObject](),
                    extraData: Data(),
                    transactionOptions: options)!
                    
                    let password = AppDataModelManager.shared.getAppPinCode()
                    if password != nil {
                        
                        let result = try tx.send(password: password)
                        print(result)
                        seal.resolve(.fulfilled(true))

                    }else{
                        
                        let result = try tx.call()
                        // fulfill are result from contract
                        let anyResult = result["0"] as Any
                        seal.resolve(.fulfilled(anyResult))
                    }
                }catch {
                    
                    print("SEND FAIL \(error)")
                    seal.reject(error)

                }
            }
        }
        
        response.done({result in
            
            print(result)
            completion(result as! Bool)
        })
    }
    
    func sendEdge2(toAddr: String, wallet: WalletDataModel, amt: String, key: String, completion: @escaping (Bool)-> Void) {
        
        let network = AppDataModelManager.shared.getNetworkStatus()
        
        var web3 = Web3.InfuraMainnetWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
        }
        
        guard let ewallet = wallet.wallet else { return }
        let data = ewallet.data
        let keystoreManager: KeystoreManager
        if ewallet.isHD {
            let keystore = BIP32Keystore(data)!
            keystoreManager = KeystoreManager([keystore])
        } else {
            let keystore = EthereumKeystoreV3(data)!
            keystoreManager = KeystoreManager([keystore])
        }
        
        web3.addKeystoreManager(keystoreManager)
        
        
        let value: String = amt // Any amount of Ether you need to send
        let walletAddress = EthereumAddress(ewallet.address)! // Your wallet address
        
        let tAddress = EthereumAddress(toAddr)
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        //let parameters: [tAddress as Any, amount as Any] as [AnyObject],
        
        let erc20ContractAddress = EthereumAddress(network.getDepositTokenAddress(), ignoreChecksum: true)!
        //let erc20ContractAddress = EthereumAddress("0xbf57cd6638fdfd7c4fa4c10390052f7ab3a1c301")
        let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasLimit = .automatic
        options.gasPrice = .automatic

        let contractMethod = "transfer"
        if let transaction = contract.write(contractMethod, parameters: [tAddress, UInt(amount ?? 0)] as [AnyObject], extraData: Data(), transactionOptions: options) {
            
            do {
                let password = AppDataModelManager.shared.getAppPinCode()
                if password != nil {
                    
                let result = try transaction.send(password: password)
                
                    print(" DEPOSIT SUCCESS \(result)")
                    return
                }
            } catch {
                
                print("DEPOSIT FAIL \(error)")
                return
            }
        }
    }
    
    func sendEdge(toAddr: String, wallet: WalletDataModel, amt: String, key: String, completion: @escaping (Bool)-> Void) {
        
        let network = AppDataModelManager.shared.getNetworkStatus()
        
        var web3 = Web3.InfuraMainnetWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
        }
        
        guard let ewallet = wallet.wallet else { return }
        let data = ewallet.data
        var keystoreManager: KeystoreManager
        if ewallet.isHD {
            let keystore = BIP32Keystore(data)!
            keystoreManager = KeystoreManager([keystore])
        }else{
            let keystore = EthereumKeystoreV3(data)!
            keystoreManager = KeystoreManager([keystore])
        }
        print(keystoreManager.addresses)
        web3.addKeystoreManager(keystoreManager)
        
        
        let value: String = amt // Any amount of Ether you need to send
        let walletAddress = EthereumAddress(ewallet.address)! // Your wallet address
        
        let tAddress = EthereumAddress(toAddr)
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        //let parameters: [tAddress as Any, amount as Any] as [AnyObject],
        
        let erc20ContractAddress = EthereumAddress(network.getDepositTokenAddress(), ignoreChecksum: true)!
        let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        
        let response = Promise<Any> { seal in
            
            DispatchQueue.global().async {
                
                do {
                    
                    var options = TransactionOptions.defaultOptions
                    options.from = walletAddress
                    options.gasLimit = .manual(BigUInt(2000000))
                    options.gasPrice = .manual(BigUInt(120000000000))
                    
                    if let tx = contract.write("transfer", parameters: [tAddress, String(amount ?? "")] as [AnyObject], extraData: Data(), transactionOptions: options) {
                    
                        let password = AppDataModelManager.shared.getAppPinCode()
                        if password != nil {
                            
                            let result = try tx.send(password: password)
                            print(result)
                            seal.resolve(.fulfilled(true))

                        }else{
                            
                            let result = try tx.call()
                            // fulfill are result from contract
                            let anyResult = result["0"] as Any
                            seal.resolve(.fulfilled(anyResult))
                        }
                    }
                
                }catch {
                    
                    print("SEND FAIL \(error)")
                    seal.reject(error)

                }
            }
        }
        
        response.done({result in
            
            print(result)
            completion(result as! Bool)
        })
    }
    
    func depositCoins(wallet: WalletDataModel, toAddress: String, amount: String, key: String, completion: @escaping (Bool)-> Void) {

        let network = AppDataModelManager.shared.getNetworkStatus()
        
        var contract:web3.web3contract?
        do {
            var web3 = Web3.InfuraMainnetWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
            if AppDataModelManager.shared.testModeStatus() {
                
                web3 = Web3.InfuraRinkebyWeb3(accessToken: "f4953edd390547d3bb63dd1f76af13f2")
            }
            
            guard let ewallet = wallet.wallet else { return }
            let data = ewallet.data
            var keystoreManager: KeystoreManager
            if ewallet.isHD {
                let keystore = BIP32Keystore(data)!
                keystoreManager = KeystoreManager([keystore])
            }else{
                let keystore = EthereumKeystoreV3(data)!
                keystoreManager = KeystoreManager([keystore])
            }
            print(keystoreManager.addresses)
            web3.addKeystoreManager(keystoreManager)
            
            let ethContractAddress = EthereumAddress(network.getDepositTokenAddress(), ignoreChecksum: true)!
            
            contract = web3.contract(contractABI, at: ethContractAddress, abiVersion: 2)!
            let destAddress = toAddress
            let walletAddress = EthereumAddress(wallet.address)!
            let bridgeAddress = EthereumAddress(network.getDepositBridgeAddress())!
            
            let amt = Web3.Utils.parseToBigUInt(amount, units: .eth)
            let parameters: [AnyObject] = [bridgeAddress, String(amt ?? ""), destAddress] as [AnyObject]
            
            let response = Promise<Any> { seal in
                
                DispatchQueue.global().async {
                    
                    do {
                        // No extra data for method call
                        let extraData: Data = Data()
                        // Options for method call
                        var options = TransactionOptions.defaultOptions
                        
                        options.from = walletAddress
                        options.gasLimit = .manual(BigUInt(2000000))
                        options.gasPrice = .manual(BigUInt(120000000000))
                        
                        let tx = contract!.method("approveAndCall",
                                                  parameters: parameters as [AnyObject],
                                                  extraData: extraData,
                                                  transactionOptions: options)
                        
                        let password = AppDataModelManager.shared.getAppPinCode()
                        if password != nil {
                            
                            let result = try tx!.send(password: password)
                            print(result)
                            seal.resolve(.fulfilled(true))
                        }else{
                            
                            let result = try tx!.call()
                            // fulfill are result from contract
                            let anyResult = result["0"] as Any
                            seal.resolve(.fulfilled(anyResult))
                        }
                    }catch {
                        
                        print("DEPOSIT FAIL \(error)")
                        seal.reject(error)
                    }
                }
            }
            
            response.done({result in
                
                print(result)
            })
        }catch{
            
            print ("Failed to construct contract and/or keystoreManager \(error)")
        }
    }

    /*
    func depositCoins(wallet: WalletDataModel, toAddress: String, amount: String, key: String, completion: @escaping (Bool)-> Void) {
        
       /*
        wallet = getWallet(password: password, privateKey: "5c742b7bed0e8e5d8a70a0c4da61eea49f816904167bae09833e25035b46da55", walletName:"GanacheWallet")
        // Create contract with wallet as the sender
        contract = ProjectContract(wallet: wallet!)
        // Call contract method
        createNewProject()
        
        return
        */
        
        
        self.depositCoins2(wallet: wallet, toAddress: toAddress, amount: "100", key: key, completion: {_ in })
        return
        
        //EtherWallet2().sendCoins(wallet: wallet, toAddress: "", amount: "100", key: "", completion: {})
        //return
        
        //self.sendEdge(wallet: wallet, toAddress: "", amount: "100", key: key, completion: {_ in })
        //return
        
        let password = "web3swift"
        let key = "9b93770e1a7b0b7352ffd3017054a3272757001e5e8734c89d93f0d930f010e5" // Some private key
        let formattedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        let name = "New Wallet"
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        let wallet2 = Wallet(address: address, data: keyData, name: name, isHD: false)
        
        let data = wallet2.data
        let keystoreManager: KeystoreManager
        if wallet2.isHD {
            let keystore = BIP32Keystore(data)!
            keystoreManager = KeystoreManager([keystore])
        } else {
            let keystore = EthereumKeystoreV3(data)!
            keystoreManager = KeystoreManager([keystore])
        }
        
        
        var web3 = Web3.InfuraMainnetWeb3()
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3()
        }
        web3.addKeystoreManager(keystoreManager)
        
        let amountString = amount.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)

            
            let abiContract = self.getDepositABIContract(completion: { abiJson in
                
                let walletAddress = EthereumAddress(wallet2.address)! // Your wallet address
                let bridgeAddress = EthereumAddress(AppDataModelManager.shared.getNetworkStatus().getDepositBridgeAddress())!
                
                let parameters: [AnyObject] = [bridgeAddress as Any, UInt(100000000) as Any, "xe_0000000000000000000000000000000000000000" as Any] as [AnyObject]
                
                let contractABI = abiJson
                let contractAddress = EthereumAddress(AppDataModelManager.shared.getNetworkStatus().getDepositTokenAddress())!
                let contract = web3.contract(contractABI ?? "", at: contractAddress, abiVersion: 2)!
                
                var options = TransactionOptions.defaultOptions
                options.from = walletAddress
                options.gasLimit = .manual(BigUInt(20000000))
                options.gasPrice = .manual(BigUInt(10000000))

                DispatchQueue.global().async {
                let contractMethod = "approveAndCall" // Contract method you want to write
                if let transaction = contract.write(contractMethod, parameters: parameters as [AnyObject], extraData: Data(), transactionOptions: options) {
                    
                    do {
                        let result = try transaction.send(password: password)
                        
                        print(" DEPOSIT SUCCESS \(result)")
                        return
                    } catch {
                        
                        print("DEPOSIT FAIL \(error)")
                        return
                    }
                }
                }
            })

    }*/
    /*
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
                    return
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
    }*/
}

