//
//  Encode.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

import UIKit
import CommonCrypto

extension Data {
    
    public func toHex() -> String {
        
        return map { String(format: "%02x", try! UInt8($0)) }.joined()
    }
}

extension UInt8 {
    
    static func fromHex(hexString: String) -> UInt8 {
        
        return UInt8(strtoul(hexString, nil, 16))
    }
}

extension StringProtocol {
    
    var toBytes: [UInt8] {
        
        let hexa = Array(self)
        return stride(from: 0, to: count, by: 2).compactMap {
            
            UInt8.fromHex(hexString: String(hexa[$0..<$0.advanced(by: 2)]))
        }
    }
}

public func hash(data: [UInt8]) -> Data {
    
    var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

    _ = digest.withUnsafeMutableBytes { (digestBytes) in
        CC_SHA256(data, CC_LONG(data.count), digestBytes)
    }
    return digest
}
