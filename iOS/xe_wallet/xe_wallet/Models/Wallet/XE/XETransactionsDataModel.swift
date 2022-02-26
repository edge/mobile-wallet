//
//  Transaction.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import UIKit
import CryptoSwift

struct XETransactionsDataModel: Codable {

    var results: [XETransactionRecordDataModel]?
    var metadata: XETransactionMetaDataModel?
    
    enum CodingKeys: String, CodingKey {
        
        case results
        case metadata
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([XETransactionRecordDataModel].self, forKey: .results)
        self.metadata = try container.decode(XETransactionMetaDataModel.self, forKey: .metadata)
    }
}

struct XETransactionMetaDataModel: Codable {

    var address: String
    var totalCount: Int
    var count: Int
    var page: Int
    var limit: Int
    var skip: Int
    
    enum CodingKeys: String, CodingKey {
        
        case address
        case totalCount
        case count
        case page
        case limit
        case skip
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decode(String.self, forKey: .address)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
        self.count = try container.decode(Int.self, forKey: .count)
        self.page = try container.decode(Int.self, forKey: .page)
        self.limit = try container.decode(Int.self, forKey: .limit)
        self.skip = try container.decode(Int.self, forKey: .skip)
    }
}

struct XETransactionRecordDataModel: Codable {

    var timestamp: Int
    var sender: String
    var recipient: String
    var amount: Int
    var data: XETransactionDataDataModel?
    var nonce: Int
    var signature: String
    var hash: String
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
        case confirmations
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
        self.confirmations = try container.decode(Int.self, forKey: .confirmations)
    }
        
    public init(from pending: XETransactionPendingRecordDataModel) {
        
        self.timestamp =  pending.timestamp
        self.sender = pending.sender
        self.recipient = pending.recipient
        self.amount = pending.amount
        self.data = pending.data
        self.nonce = pending.nonce
        self.signature = pending.signature
        self.hash = pending.hash
        self.status = .pending
    }
}

struct XETransactionPendingRecordDataModel: Codable {

    var timestamp: Int
    var sender: String
    var recipient: String
    var amount: Int
    var data: XETransactionDataDataModel?
    var nonce: Int
    var signature: String
    var hash: String
    
    enum CodingKeys: String, CodingKey {
        
        case timestamp
        case sender
        case recipient
        case amount
        case data
        case nonce
        case signature
        case hash
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
    }
}


struct XETransactionDataDataModel: Codable {

    var memo: String
    
    enum CodingKeys: String, CodingKey {
        
        case memo
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memo = try container.decode(String.self, forKey: .memo)
    }
    
    public init() {
        
        self.memo = ""
    }
}

struct XETransactionBlockDataModel: Codable {

    var height: Int
    var hash: String
    
    enum CodingKeys: String, CodingKey {
        
        case height
        case hash
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.height = try container.decode(Int.self, forKey: .height)
        self.hash = try container.decode(String.self, forKey: .hash)
    }
    
    public init(height: Int, hash: String) {
        
        self.height = height
        self.hash = hash
    }
}

