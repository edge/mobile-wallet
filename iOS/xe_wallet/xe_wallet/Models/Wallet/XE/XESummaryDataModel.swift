//
//  XESummaryDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 10/03/2022.
//

import UIKit

class XESummaryDataModel: Codable {

    var latestBlock: Int?
    var latestTx: XESummaryLatestTxDataModel?
    var balances: [XESummaryBalancesDataModel]?

    enum CodingKeys: String, CodingKey {
        
        case latestBlock
        case latestTx
        case balances
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latestBlock = try container.decodeIfPresent(Int.self, forKey: .latestBlock)
        self.latestTx = try container.decodeIfPresent(XESummaryLatestTxDataModel.self, forKey: .latestTx)
        self.balances = try container.decodeIfPresent([XESummaryBalancesDataModel].self, forKey: .balances)
    }
    
    public init(latestBlock: Int, latestTx: XESummaryLatestTxDataModel, balances: [XESummaryBalancesDataModel]) {
        
        self.latestBlock = latestBlock
        self.latestTx = latestTx
        self.balances = balances
    }
}

struct XESummaryLatestTxDataModel: Codable {

    var timestamp: Int?
    var sender: String?
    var recipient: String?
    var amount: Int?
    var data: XETransactionDataDataModel?
    var nonce: Int?
    var signature: String?
    var hash: String?
    var block: XETransactionBlockDataModel?
    var confirmations: Int?
    var status: TransactionStatus?
    
    enum CodingKeys: String, CodingKey {
        
        case timestamp
        case sender
        case recipient
        case amount
        case data
        case nonce
        case signature
        case hash
        case block
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(Int.self, forKey: .timestamp)
        self.sender = try container.decode(String.self, forKey: .sender)
        self.recipient = try container.decode(String.self, forKey: .recipient)
        self.amount = try container.decode(Int.self, forKey: .amount)
        self.data = try container.decode(XETransactionDataDataModel.self, forKey: .data)
        self.nonce = try container.decode(Int.self, forKey: .nonce)
        self.signature = try container.decode(String.self, forKey: .signature)
        self.hash = try container.decode(String.self, forKey: .hash)
        self.block = try container.decode(XETransactionBlockDataModel.self, forKey: .block)
    }
}

class XESummaryBalancesDataModel: Codable {

    var address: String?
    var balance: Int?
    var nonce: Int?
    var latestTx: XESummaryBalancesLatestTxDataModel?
    
    enum CodingKeys: String, CodingKey {
        
        case address
        case balance
        case nonce
        case latestTx
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.balance = try container.decodeIfPresent(Int.self, forKey: .balance)
        self.nonce = try container.decodeIfPresent(Int.self, forKey: .nonce)
        self.latestTx = try container.decodeIfPresent(XESummaryBalancesLatestTxDataModel.self, forKey: .latestTx)
    }
    
    public init(address: String, balance: Int, nonce: Int, latestTx: XESummaryBalancesLatestTxDataModel) {
        
        self.address = address
        self.balance = balance
        self.nonce = nonce
        self.latestTx = latestTx
    }
}

class XESummaryBalancesLatestTxDataModel: Codable {

    var hash: String?
    var block: Int?

    enum CodingKeys: String, CodingKey {
        
        case hash
        case block
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hash = try container.decodeIfPresent(String.self, forKey: .hash)
        self.block = try container.decodeIfPresent(Int.self, forKey: .block)
    }
    
    public init(hash: String, block: Int) {
        
        self.hash = hash
        self.block = block
    }
}




