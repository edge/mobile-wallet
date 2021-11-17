//
//  Transaction.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation
import CryptoSwift

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
    var amount: Int
    var data: TransactionDataDataModel?
    var nonce: Int
    var signature: String
    var hash: String
    var block: TransactionBlockDataModel?
    var confirmations: Int
    
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
        self.data = try container.decode(TransactionDataDataModel.self, forKey: .data)
        self.nonce = try container.decode(Int.self, forKey: .nonce)
        self.signature = try container.decode(String.self, forKey: .signature)
        self.hash = try container.decode(String.self, forKey: .hash)
        self.block = try container.decode(TransactionBlockDataModel.self, forKey: .block)
        self.confirmations = try container.decode(Int.self, forKey: .confirmations)
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
}


/*
{
results: [
{
timestamp: 1635067821580,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_D9074442fa2049f22e0aaBF9791a76Df3a95d770",
amount: 6626250000,
data: {
memo: "XE Distribution"
},
nonce: 607,
signature: "50631e3c741395b8dca8fc97d0896d0477d53e717ff9b96ce0220a5f4f47603966e656f1596db52c4699d589aea0b640b672a04bdf1758861e7c9298abc4229400",
hash: "46e5631c4d711e9c3a56d8672446ba2b569efbcbff0a82ad579fe5f8660e8954",
block: {
height: 191973,
hash: "0000031236833dbdad1cef3d8d922d4b691f493b638a00d866452e296607e4d0"
},
confirmations: 33044
},
{
timestamp: 1635067785533,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_EB68B02BA632F03349B210452fbe288bA4930847",
amount: 39999028770,
data: {
memo: "XE Distribution"
},
nonce: 606,
signature: "b483b8dd2a27b4955618d7b0f635f7fb222b6a214a4a503bf7c2558bf2d6f49010f168b094a64d010b0ea4881bd45a4464116220f4a5d298db9e7b1c53c16f3901",
hash: "d0dec8a76a6422a8f06a35f3d67da4cfe31cad7f2927e7a10ee60c94c4a7ec30",
block: {
height: 191972,
hash: "000002d46ebb95186b0008f11d16b55a62204662459eab1b9a376853e5fd2b8e"
},
confirmations: 33045
},
{
timestamp: 1634233657304,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_2455b08eb7c53F62c27b47Ec22E559712a455d96",
amount: 4725450000,
data: {
memo: "XE Distribution"
},
nonce: 605,
signature: "b70c80aad3eadc07f48b1ed5bbc601096f4bbfeee13fc09c604de10c851ac0563aa1cb7c8ac81f7626d420d6ccfaa54709317a899e89427240fd093a509efaad01",
hash: "32c1efb922890f631a0a2a37d8a264970aacbefb2d9d0293d25f1b57f2a82165",
block: {
height: 178850,
hash: "000007fa1e58a3d2251c5d09ccd3a8720b7a5d2baee96ef7193ca4c8f569652d"
},
confirmations: 46167
},
{
timestamp: 1633095047803,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_974f19E3E467b52336792e51E29e032B98Bb18b7",
amount: 14075546805,
data: {
memo: "XE Distribution"
},
nonce: 604,
signature: "bf46884a94df48fdb315a19b5dc312107f48fed378b21c08b36e5242739a44f90f6e32cd4c4754f7f24b96b36a729f23e6bb099d5eede0c40a2fac2be736ba6000",
hash: "cf505b42f50f94291c53b5095cb3b8eda49e0d372227ed74ac1987a695dfbfa6",
block: {
height: 160942,
hash: "00000b11498ea7091dc9722a1fbceec7ac26318a867d1922cb408a7dec53be8e"
},
confirmations: 64075
},
{
timestamp: 1633088509449,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_C9071735175f77Cf5A78e76719D0aB371a751318",
amount: 381657863,
data: {
memo: "XE Distribution"
},
nonce: 603,
signature: "752e8b423eb9aea5e179842195f99fea608fab947bc04b73dad203ab496f950303520a06d5627f4a7406b9ad741100580ddcace5eba789f1e0212880f8124ac801",
hash: "62055ce035d0ec5d8584425e95b5640330e61c32c3dd3fd1db6c4873c677ed67",
block: {
height: 160839,
hash: "00000d47b4bbf34fd52f3e65d8dc829484aeadb9512b1df866663f6edecc13d4"
},
confirmations: 64178
},
{
timestamp: 1633088488409,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_59503c4d2040d3d76b4c30D823Ee826B33F6e786",
amount: 1026470597,
data: {
memo: "XE Distribution"
},
nonce: 602,
signature: "59459fb8e2d1c9406f86f1190b2bc2e4b5fcbe414d95ad425946958418b6457f380079ff18b65eb2454c25bdded4789c5253cb498ddb465ad850d4b885ab392900",
hash: "18f4e53a14bc71d868c5fe85c28200870e237dbc1c8f8c7b14e8a9919c7ce265",
block: {
height: 160839,
hash: "00000d47b4bbf34fd52f3e65d8dc829484aeadb9512b1df866663f6edecc13d4"
},
confirmations: 64178
},
{
timestamp: 1633088469621,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_5136F435cb98008CF627D4f6230BBEdD85ab2983",
amount: 943748487,
data: {
memo: "XE Distribution"
},
nonce: 601,
signature: "9cef712c42a4b7aae15e089742421ff052d1504fdc57cd65fee39a3c6e4faf2720646fb4f4539738bb6be9cd9686a9095b6a5399ac5342a22cbea2dc5a19dcce00",
hash: "9a18ac1c50ecb29edb50b4e6aeb54c4e97466a5c6f8bbd79dd48463ed9ec1b0f",
block: {
height: 160839,
hash: "00000d47b4bbf34fd52f3e65d8dc829484aeadb9512b1df866663f6edecc13d4"
},
confirmations: 64178
},
{
timestamp: 1633088448423,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_812F7556A62c4969B3b43C8713a98735fB6914C2",
amount: 3255076530,
data: {
memo: "XE Distribution"
},
nonce: 600,
signature: "958b6844fd8c39bfa45401fc1658d544076608f77b4dc2c33639143e2bd2065a619a6b0bedcb1e47e3e8630e1287be481ade4be6ce45ffbfe44370436cff5ea500",
hash: "4c501a9e11b0e1ea0297dfba4225f941e3b05e9b2e1a0de0b88edb848be94619",
block: {
height: 160838,
hash: "00000aaf575ca1ba12eca96da76f0b9d9227bb56a83d402e16044abd3930de23"
},
confirmations: 64179
},
{
timestamp: 1633088426446,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_2117347ef24A13439a311e161318AAD393170E68",
amount: 2373750000,
data: {
memo: "XE Distribution"
},
nonce: 599,
signature: "4f7681662b282c89c361e253f39cc35cf8250d3047979f6e52e629c9a8ed53f5003108a49ed94abda58d30dec14ce39c1d7dec367ac777013e146a50f01cf1d601",
hash: "77ab6f41e47292dc7530009727a61b73d4c1b411faa97e01eb1eb6d00af42fb9",
block: {
height: 160838,
hash: "00000aaf575ca1ba12eca96da76f0b9d9227bb56a83d402e16044abd3930de23"
},
confirmations: 64179
},
{
timestamp: 1632993072242,
sender: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
recipient: "xe_D0c1586Eb6e6551cfce08153fE8fAe16b3288460",
amount: 132910250000,
data: {
memo: "XE Distribution"
},
nonce: 598,
signature: "576a70e2814ec255418325a4e8afe4d713aa6dcdcfd060eda848c8dd96468d364659a5705406dce5d52d71d504eaecaf0983666b5c516b14775474e839f6e74901",
hash: "23bba357368794454a3885d4a4c12fb5710e215a464f46f3dc02d6c3bc0617c4",
block: {
height: 159337,
hash: "000005596b1bb5045fb01a6ec17d098746dce90c86863d8e6a06f9a2cc9cfe59"
},
confirmations: 65680
}
],
metadata: {
address: "xe_ed9e05C9c85Ec8c46c333111a1C19035b5ECba99",
totalCount: 609,
count: 10,
page: 1,
limit: 10,
skip: 0
}
}
*/
