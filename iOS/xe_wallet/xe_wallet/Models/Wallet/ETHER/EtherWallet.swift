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
        
    public func generateWallet(type:WalletType) -> AddressKeyPairModel? {

        let password = AppDataModelManager.shared.getAppPinCode()
        do {
            let keystore = try! EthereumKeystoreV3(password:password)!
            let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
            let address = keystore.addresses!.first!.address
            let ethereumAddress = EthereumAddress(address)!
            let pkData = try! keystore.UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress).toHexString()
            let wallet = Wallet(address: address, data: keyData, name: "", isHD: false)
            return  AddressKeyPairModel(privateKey: pkData , address: address, wallet: wallet)

        } catch let error as NSError {
            if error.code == 0 {
                print("Error code: 0")
            }
        }
        return nil
    }
    
    public func generateWalletFromPrivateKey(privateKeyString: String) -> AddressKeyPairModel {

        let password = AppDataModelManager.shared.getAppPinCode()
        let formattedKey = privateKeyString.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keyStore = try! EthereumKeystoreV3(privateKey:dataKey, password: password)!
        let keyData = try! JSONEncoder().encode(keyStore.keystoreParams)
        let address = keyStore.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: "", isHD: false)
        return AddressKeyPairModel(privateKey: privateKeyString, address: address, wallet: wallet)
    }
    
    public func downloadStatus(address: String, completion: @escaping (WalletStatusDataModel?)-> Void) {

        var web3 = Web3.InfuraMainnetWeb3(accessToken: Constants.infuraToken)
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3(accessToken: Constants.infuraToken)
        }

        DispatchQueue.global().async {
            let walletAddress = EthereumAddress(address)!
            
            do {
                let balanceResult = try web3.eth.getBalance(address: walletAddress)
                var bs = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 6)!
                
                let network = AppDataModelManager.shared.getNetworkStatus()
                
                var erc20Tokens:[ERC20TokenDataModel] = []
                
                for erc20 in ERC20TokenType.allCases {
                    
                    let exploredAddress = EthereumAddress(address)!
                    let erc20ContractAddress = EthereumAddress(erc20.getContractAddress())!
                    
                    //let erc20ContractAddress = EthereumAddress(network.getDepositTokenAddress())!
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
                    
                    
                    var balance = "0.0"
                    if let token = tokenBalance["0"] {
                        
                        let big = BigUInt.init("\(token)", erc20.getTokenUnitType())!
                        balance = Web3.Utils.formatToEthereumUnits(big, toUnits: .eth, decimals: 6)!
                    }
                    
                    erc20Tokens.append(ERC20TokenDataModel(type: erc20.getMainType(), tokenType:erc20, balance: Double(balance) ?? 0.0))
                }
                
                completion(WalletStatusDataModel(address: address, balance:Double(bs) ?? 0, erc20Tokens: erc20Tokens, nonce:0))
                
                //completion(EtherWalletStatusDataModel(address: address, balance:Double(bs) ?? 0, nonce:0, edgeBalance:0.0, erc20Tokens: erc20Tokens))
                

            }
            catch {
                
            }
        }
    }
    
    func downloadTransactions(address: String, completion: @escaping ([TransactionDataModel]?)-> Void) {
                
        let apiUrl = "https://api-rinkeby.etherscan.io/api?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=10&sort=asc"
        let apiKey = "2HA3ZV1XH4JHEVRA7J534AJ1PUGQVVKD4V"
        let url = "\(apiUrl)&address=\(address)&apikey=\(apiKey)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            switch (response.result) {

                case .success( _):

                do {
                                        
                    let data = try JSONDecoder().decode(EtherTransactionsDataModel.self, from: response.data!)

                    var transArray:[TransactionDataModel] = []
                    if let results = data.result {
                        
                        for res in results {
                            
                            var trans = TransactionDataModel()
                            
                            trans.timestamp = Int(res.timeStamp ?? "0") ?? 0
                            trans.sender = res.from ?? ""
                            trans.recipient = res.to ?? ""
                            let newVal: String = String(res.value?.dropLast(12) ?? "0")
                            let damt = Double(newVal) ?? 0
                            let amt = damt / 1000000
                            trans.amount = amt
                            trans.data = TransactionDataDataModel()
                            trans.nonce = Int(res.nonce ?? "0") ?? 0
                            trans.signature = ""
                            trans.hash = res.hash ?? ""
                            trans.block = TransactionBlockDataModel(height: Int(res.blockNumber ?? "0") ?? 0, hash: res.blockHash ?? "")
                            trans.confirmations = Int(res.confirmations ?? "0") ?? 0
                            trans.status = .confirmed
                            trans.type = .ethereum
                            transArray.append(trans)
                        }
                    }
                    
                    completion(transArray)

                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                }
                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
             }
        }
    }
    
    func downloadTokenTransations(address: String, type: WalletType, completion: @escaping ([TransactionDataModel]?)-> Void) {
    
        //http://api.etherscan.io/api?module=account&action=tokentx&address=0x9f7dd5ea934d188a599567ee104e97fa46cb4496&startblock=0&endblock=999999999&sort=asc&apikey=YourApiKeyToken
        
        let apiUrl = "https://api-rinkeby.etherscan.io/api?module=account&action=tokentx&startblock=0&endblock=99999999&page=1&offset=10&sort=asc"
        let apiKey = "2HA3ZV1XH4JHEVRA7J534AJ1PUGQVVKD4V"
        let url = "\(apiUrl)&token=0xbf57cd6638fdfd7c4fa4c10390052f7ab3a1c301&address=\(address)&apikey=\(apiKey)"
        
        //let url = "https://rinkeby.etherscan.io/token/0xbf57cd6638fdfd7c4fa4c10390052f7ab3a1c301?a=0x8b9bD05Fe9fF20b185d682F664AeEe763023d9b9"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            switch (response.result) {

                case .success( _):

                do {
                                        
                    let data = try JSONDecoder().decode(EtherTransactionsDataModel.self, from: response.data!)
                    
                    var transArray:[TransactionDataModel] = []
                    if let results = data.result {
                        
                        for res in results {
                            
                            var trans = TransactionDataModel()
                            
                            trans.timestamp = Int(res.timeStamp ?? "0") ?? 0
                            trans.sender = res.from ?? ""
                            trans.recipient = res.to ?? ""
                            let newVal: String = String(res.value?.dropLast(12) ?? "0")
                            let damt = Double(newVal) ?? 0
                            let amt = damt / 1000000
                            trans.amount = amt
                            trans.data = TransactionDataDataModel()
                            trans.nonce = Int(res.nonce ?? "0") ?? 0
                            trans.signature = ""
                            trans.hash = res.hash ?? ""
                            trans.block = TransactionBlockDataModel(height: Int(res.blockNumber ?? "0") ?? 0, hash: res.blockHash ?? "")
                            trans.confirmations = Int(res.confirmations ?? "0") ?? 0
                            trans.status = .confirmed
                            trans.type = .edge
                            transArray.append(trans)
                        }
                    }
                    completion(transArray)
                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                }
                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
             }
        }
    }
    
    public func sendEther(toAddr: String, wallet: WalletDataModel, amt: String, key: String, completion: @escaping (Bool)-> Void) {
        
        var web3 = Web3.InfuraMainnetWeb3(accessToken: Constants.infuraToken)
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3(accessToken: Constants.infuraToken)
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
    
    func sendEdge(toAddr: String, wallet: WalletDataModel, amt: String, key: String, completion: @escaping (Bool)-> Void) {
        
        let network = AppDataModelManager.shared.getNetworkStatus()
        
        var web3 = Web3.InfuraMainnetWeb3(accessToken: Constants.infuraToken)
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3(accessToken: Constants.infuraToken)
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
            var web3 = Web3.InfuraMainnetWeb3(accessToken: Constants.infuraToken)
            if AppDataModelManager.shared.testModeStatus() {
                
                web3 = Web3.InfuraRinkebyWeb3(accessToken: Constants.infuraToken)
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
                completion(result as! Bool)
            })
        }catch{
            
            print ("Failed to construct contract and/or keystoreManager \(error)")
        }
    }
}

