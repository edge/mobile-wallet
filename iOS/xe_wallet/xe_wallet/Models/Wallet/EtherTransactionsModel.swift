//
//  EtherTransactionsModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 19/11/2021.
//

import Foundation

class EtherTransactionsModel: Codable {
    
    var result: [EtherTransactionDataModel]?
    var status: String?
}

class EtherTransactionDataModel: Codable {
    
    var blockHash: String?
    var blockNumber: String?
    var confirmations: String?
    var contractAddress: String?
    var cumulativeGasUsed: String?
    var from: String?
    var gas: String?
    var gasPrice: String?
    var gasUsed: String?
    var hash: String?
    var input: String?
    var isError: String?
    var nonce: String?
    var timeStamp: String?
    var to: String?
    var transactionIndex: String?
    var txreceipt_status: String?
    var value: String?
}
