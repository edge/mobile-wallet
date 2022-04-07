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

enum TransactionStatus: String, Codable {
    
    case pending = "Pending"
    case confirmed = "Confirmed"
}


struct TransactionDataModel: Codable {

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
    var gas: String?
    var gasPrice: String?
    var gasUsed: String?
    
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
        case status
        case type
        case gas
        case gasPrice
        case gasUsed
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(Int.self, forKey: .timestamp)
        self.sender = try container.decode(String.self, forKey: .sender)
        self.recipient = try container.decode(String.self, forKey: .recipient)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.data = try container.decodeIfPresent(TransactionDataDataModel.self, forKey: .data)
        self.nonce = try container.decode(Int.self, forKey: .nonce)
        self.signature = try container.decode(String.self, forKey: .signature)
        self.hash = try container.decode(String.self, forKey: .hash)
        self.block = try container.decodeIfPresent(TransactionBlockDataModel.self, forKey: .block)
        self.confirmations = try container.decodeIfPresent(Int.self, forKey: .confirmations)
        self.status = try container.decodeIfPresent(TransactionStatus.self, forKey: .status)
        self.type = try container.decodeIfPresent(WalletType.self, forKey: .type)
        self.gas = try container.decodeIfPresent(String.self, forKey: .gas)
        self.gasPrice = try container.decodeIfPresent(String.self, forKey: .gasPrice)
        self.gasUsed = try container.decodeIfPresent(String.self, forKey: .gasUsed)
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
        self.gas = ""
        self.gasPrice = ""
        self.gasUsed = ""
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
    
    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(memo, forKey: .memo)
    }
    
    public init() {
        
        self.memo = ""
    }
    
    public init(memo: String) {
        
        self.memo = memo
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
    
    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(height, forKey: .height)
        try container.encode(hash, forKey: .hash)
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


