//
//  XESummaryDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 10/03/2022.
//

import UIKit

class XESummaryDataModel: Codable {

    var latestBlock: Int?
    var wallets: [XESummaryWalletsDataModel]?

    enum CodingKeys: String, CodingKey {
        
        case latestBlock
        case wallets
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latestBlock = try container.decodeIfPresent(Int.self, forKey: .latestBlock)
        self.wallets = try container.decodeIfPresent([XESummaryWalletsDataModel].self, forKey: .wallets)
    }
    
    public init(latestBlock: Int, wallets: [XESummaryWalletsDataModel]) {
        
        self.latestBlock = latestBlock
        self.wallets = wallets
    }
}

class XESummaryWalletsDataModel: Codable {

    var address: String?
    var balance: Int?
    var nonce: Int?
    var latestTx: XESummaryBalancesLatestTxDataModel?
    var pendingTxs: [XETransactionPendingRecordDataModel]?
    
    enum CodingKeys: String, CodingKey {
        
        case address
        case balance
        case nonce
        case latestTx
        case pendingTxs
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.balance = try container.decodeIfPresent(Int.self, forKey: .balance)
        self.nonce = try container.decodeIfPresent(Int.self, forKey: .nonce)
        self.latestTx = try container.decodeIfPresent(XESummaryBalancesLatestTxDataModel.self, forKey: .latestTx)
        self.pendingTxs = try container.decodeIfPresent([XETransactionPendingRecordDataModel].self, forKey: .pendingTxs)
    }
    
    public init(address: String, balance: Int, nonce: Int, latestTx: XESummaryBalancesLatestTxDataModel, pendingTxs: [XETransactionPendingRecordDataModel]) {
        
        self.address = address
        self.balance = balance
        self.nonce = nonce
        self.latestTx = latestTx
        self.pendingTxs = pendingTxs
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




