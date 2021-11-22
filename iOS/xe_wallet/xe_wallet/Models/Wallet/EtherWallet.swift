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
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
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
    
    public func downloadStatus(address: String, completion: @escaping (WalletStatusDataModel)-> Void) {

        var web3 = Web3.InfuraMainnetWeb3()
        if AppDataModelManager.shared.testModeStatus() {
            
            web3 = Web3.InfuraRinkebyWeb3()
        }

        let walletAddress = EthereumAddress(address)!
        let balanceResult = try! web3.eth.getBalance(address: walletAddress)
        var bs = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 6)!
        bs = bs.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        completion(WalletStatusDataModel(address: address, balance:Int(bs) ?? 0, nonce:0))
    }
    
    func downloadTransactions(address: String, completion: @escaping (TransactionsDataModel)-> Void) {
        
        let apiUrl = "https://api-rinkeby.etherscan.io/api?module=account&action=txlist&startblock=0&endblock=99999999&page=1&offset=10&sort=asc"
        let apiKey = "2HA3ZV1XH4JHEVRA7J534AJ1PUGQVVKD4V"
        
        let url = "\(apiUrl)&address=\(address)&apikey=\(apiKey)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            switch (response.result) {

                case .success( _):

                do {
                    let data = try JSONDecoder().decode(EtherTransactionsModel.self, from: response.data!)
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
}

