//
//  TransactionsDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 26/11/2021.
//

import UIKit
import CryptoSwift
import web3swift
import BigInt

enum TransactionType: String {
    
    case send = "Sent"
    case receive = "Received"
    case exchange = "Exchanged"
    
    func getImageName() -> String {
        
        switch self {
        case .send:
            return "send"
            
        case .receive:
            return "receive"
            
        case .exchange:
            return "exchange"
        }
    }
}

enum TransactionStatus: String {
    
    case pending = "Pending"
    case confirmed = "Confirmed"
}


struct TransactionsDataModel: Codable {

    var results: [TransactionRecordDataModel]?
    var metadata: TransactionMetaDataModel?
    
    enum CodingKeys: String, CodingKey {
        
        case results
        case metadata
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([TransactionRecordDataModel].self, forKey: .results)
        self.metadata = try container.decode(TransactionMetaDataModel.self, forKey: .metadata)
    }
    
    public init(from xe: XETransactionsDataModel) {
        
        guard let results = xe.results else { return }
        
        var res = [TransactionRecordDataModel]()

        for n in results {
            
            let newRecord = TransactionRecordDataModel(from: n)
            res.append(newRecord)
        }
        self.results = res
    }
    
    public init(from ether: EtherTransactionsDataModel, type: WalletType) {
        
        guard let results = ether.result else { return }
        
        var res = [TransactionRecordDataModel]()

        for n in results {
            
            let newRecord = TransactionRecordDataModel(from: n, type: type)
            res.append(newRecord)
        }
        self.results = res
    }
}

struct TransactionMetaDataModel: Codable {

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

struct TransactionRecordDataModel: Codable {

    var timestamp: Int
    var sender: String
    var recipient: String
    var amount: Double
    var data: TransactionDataDataModel?
    var nonce: Int
    var signature: String
    var hash: String
    var block: TransactionBlockDataModel?
    var confirmations: Int?
    var status: TransactionStatus?
    var type: WalletType?
    
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
        case type
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(Int.self, forKey: .timestamp)
        self.sender = try container.decode(String.self, forKey: .sender)
        self.recipient = try container.decode(String.self, forKey: .recipient)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.data = try container.decode(TransactionDataDataModel.self, forKey: .data)
        self.nonce = try container.decode(Int.self, forKey: .nonce)
        self.signature = try container.decode(String.self, forKey: .signature)
        self.hash = try container.decode(String.self, forKey: .hash)
        self.block = try container.decode(TransactionBlockDataModel.self, forKey: .block)
        self.confirmations = try container.decode(Int.self, forKey: .confirmations)
        self.type = try container.decode(WalletType.self, forKey: .type)
    }
    
    public init(from ether: EtherTransactionDataModel, type: WalletType) {
        
        self.timestamp = Int(ether.timeStamp ?? "0") ?? 0
        self.sender = ether.from ?? ""
        self.recipient = ether.to ?? ""
        
        let newVal: String = String(ether.value?.dropLast(12) ?? "0")
        let damt = Double(newVal) ?? 0
        let amt = damt / 1000000
        self.amount = amt
        self.data = TransactionDataDataModel()
        self.nonce = Int(ether.nonce ?? "0") ?? 0
        self.signature = ""
        self.hash = ether.hash ?? ""
        self.block = TransactionBlockDataModel(height: Int(ether.blockNumber ?? "0") ?? 0, hash: ether.blockHash ?? "")
        self.confirmations = Int(ether.confirmations ?? "0") ?? 0
        self.status = .confirmed
        self.type = type
    }
    
    public init(from xe: XETransactionRecordDataModel) {
        
        self.timestamp = xe.timestamp/1000
        self.sender = xe.sender
        self.recipient = xe.recipient
        self.amount = Double(xe.amount / 1000000)
        if let data = xe.data {
            
            self.data = TransactionDataDataModel(from: data)
        } else {
            
            self.data = nil
        }
        self.nonce = xe.nonce
        self.signature = xe.signature
        self.hash = xe.hash
        if let block = xe.block {
            
            self.block = TransactionBlockDataModel(from: block)
        } else {
            
            self.block = nil
        }
        self.confirmations = xe.confirmations
        self.status = .confirmed
        self.type = .xe
    }
    
    public init(from pending: XETransactionPendingRecordDataModel) {
        
        self.timestamp =  pending.timestamp
        self.sender = pending.sender
        self.recipient = pending.recipient
        self.amount = Double(pending.amount / 1000000)
        if let data = pending.data {
            
            self.data = TransactionDataDataModel(from: data)
        } else {
            
            self.data = nil
        }
        self.nonce = pending.nonce
        self.signature = pending.signature
        self.hash = pending.hash
        self.status = .pending
    }
    
    public init() {
        
        self.timestamp =  0
        self.sender = ""
        self.recipient = ""
        self.amount = 0
        self.data = TransactionDataDataModel()
        self.nonce = 0
        self.signature = ""
        self.hash = ""
        self.block = TransactionBlockDataModel(height: 0, hash: "")
        self.confirmations = 0
        self.status = .confirmed
    }
}

struct TransactionPendingRecordDataModel: Codable {

    var timestamp: Int
    var sender: String
    var recipient: String
    var amount: Int
    var data: TransactionDataDataModel?
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
        self.data = try container.decode(TransactionDataDataModel.self, forKey: .data)
        self.nonce = try container.decode(Int.self, forKey: .nonce)
        self.signature = try container.decode(String.self, forKey: .signature)
        self.hash = try container.decode(String.self, forKey: .hash)
    }
    
    public init(from xe: XETransactionPendingRecordDataModel) {
        
        self.timestamp = xe.timestamp
        self.sender = xe.sender
        self.recipient = xe.recipient
        self.amount = xe.amount
        if let data = xe.data {
            
            self.data = TransactionDataDataModel(from: data)
        } else {
            
            self.data = nil
        }
        self.nonce = xe.nonce
        self.signature = xe.signature
        self.hash = xe.hash
    }
}


struct TransactionDataDataModel: Codable {

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
    
    public init(from xe:XETransactionDataDataModel) {
        
        self.memo = xe.memo
    }
}

struct TransactionBlockDataModel: Codable {

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
    
    public init(from xe: XETransactionBlockDataModel) {
        
        self.height = xe.height
        self.hash = xe.hash
    }
}


