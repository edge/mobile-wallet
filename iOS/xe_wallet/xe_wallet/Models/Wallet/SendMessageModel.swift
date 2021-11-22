//
//  SendMessageModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 21/11/2021.
//


import UIKit

class SendMessageModel: Codable {

    var dat1: UInt64?
    var dat2: String?
    var dat3: String?
    var dat4: Int?
    var dat5: SendMessageDataModel?
    var dat6: Int?
    var dat7: String?
    var dat8: String?

    
    enum CodingKeys: String, CodingKey {
        
        case dat1
        case dat2
        case dat3
        case dat4
        case dat5
        case dat6
        case dat7
        case dat8
    }
    
    public init(timestamp: UInt64, sender: String, recipient: String, amount: Int, data: SendMessageDataModel, nonce: Int) {
        
        self.dat1 = timestamp
        self.dat2 = sender
        self.dat3 = recipient
        self.dat4 = amount
        self.dat5 = data
        self.dat6 = nonce
        self.dat7 = nil
        self.dat8 = nil
    }
}

class SendMessageDataModel: Codable {
    
    var memo: String?
    
    enum CodingKeys: String, CodingKey {
        
        case memo
    }
    
    public init(memo: String) {
        
        self.memo = memo
    }
}
