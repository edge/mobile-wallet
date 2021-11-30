//
//  EtherWallet2.swift
//  xe_wallet
//
//  Created by Paul Davis on 29/11/2021.
//

import SwiftKeccak
import UIKit
import Security
//import web3swift
import secp256k1
import Alamofire

import Web3
import PromiseKit
import Web3ContractABI

import BigInt
import SwiftyJSON


class EtherWallet2 {
    
    func getBalance(address: String) {
        /*
        let web3 = Web3(rpcURL: AppDataModelManager.shared.getNetworkStatus().getInfuraUrl())

        let contractAddress = try! EthereumAddress(hexString: AppDataModelManager.shared.getNetworkStatus().getDepositTokenAddress())!
        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)

        // Get balance of some address
        firstly {
            try contract.balanceOf(address: EthereumAddress(hex: address, eip55: true)).call()
        }.done { outputs in
            print(outputs["_balance"] as? BigUInt)
        }.catch { error in
            print(error)
        }*/
    }
    

    
    /*func sendCoins(wallet: WalletDataModel, toAddress: String, amount: String, key: String, completion: @escaping (Bool)-> Void) {
        
        let web3 = Web3(rpcURL: AppDataModelManager.shared.getNetworkStatus().getInfuraUrl())
        
        let contractAddress = try! EthereumAddress(hex: "0xbf57cd6638fdfd7c4fa4c10390052f7ab3a1c301", eip55: true)
        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)

        // Get balance of some address
        firstly {
            try contract.balanceOf(address: EthereumAddress(hex: "0x8b9bD05Fe9fF20b185d682F664AeEe763023d9b9", eip55: true)).call()
        }.done { outputs in
            print(outputs["_balance"] as? BigUInt)
        }.catch { error in
            print(error)
        }

        // Send some tokens to another address (locally signing the transaction)
        let myPrivateKey = try! EthereumPrivateKey(hexPrivateKey: "9b93770e1a7b0b7352ffd3017054a3272757001e5e8734c89d93f0d930f010e5")
        firstly {
            web3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest)
        }.then { nonce in
            try contract.transfer(to: EthereumAddress(hex: "0x05D7F6CD1cDc12A5e623d7A4c0f1E22842757D20", eip55: true), value: 100000).createTransaction(
                nonce: nonce,
                from: myPrivateKey.address,
                value: 0,
                gas: 100000,
                gasPrice: EthereumQuantity(quantity: 21.gwei)
            )!.sign(with: myPrivateKey).promise
        }.then { tx in
            web3.eth.sendRawTransaction(transaction: tx)
        }.done { txHash in
            print(txHash)
        }.catch { error in
            print(error)
        }
    }*/
    
    func depositCoins(wallet: WalletDataModel, toAddress: String, amount: String, key: String, completion: @escaping (Bool)-> Void) {
        
        let web3 = Web3(rpcURL: AppDataModelManager.shared.getNetworkStatus().getInfuraUrl())
        /*
        let abiContract = self.getDepositABIContract(completion: { abiJson in
            
            let contractAddress = try! EthereumAddress(hex: AppDataModelManager.shared.getNetworkStatus().getDepositTokenAddress(), eip55: true)
            let contractJsonABI = abiJson.data(using: .utf8)!
            // You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
            let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
            
            print(contract.methods.count)
            
            // Get balance of some address
            firstly {
                try contract["balanceOf"]!(EthereumAddress(hex: "0x3edB3b95DDe29580FFC04b46A68a31dD46106a4a", eip55: true)).call()
            }.done { outputs in
                print(outputs["_balance"] as? BigUInt)
            }.catch { error in
                print(error)
            }
            
            // Send some tokens to another address (locally signing the transaction)
            let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: "...")
            guard let transaction = contract["transfer"]?(EthereumAddress.testAddress, BigUInt(100000)).createTransaction(nonce: 0, from: myPrivateKey.address, value: 0, gas: 150000, gasPrice: EthereumQuantity(quantity: 21.gwei)) else {
                return
            }
            let signedTx = try transaction.sign(with: myPrivateKey)
            
            firstly {
                web3.eth.sendRawTransaction(transaction: signedTx)
            }.done { txHash in
                print(txHash)
            }.catch { error in
                print(error)
            }
        })*/
    }
    

}

