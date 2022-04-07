//
//  Secp256k1PublicKey.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

import UIKit

public class Secp256k1PublicKey: PublicKey {
    
    public static var algorithmName = "secp256k1"
    let pubKey: [UInt8]

    init(pubKey: [UInt8]) {
        
        self.pubKey = pubKey
    }

    public static func fromHex(hexPubKey: String) -> Secp256k1PublicKey {
        
        return Secp256k1PublicKey(pubKey: hexPubKey.toBytes)
    }

    public func hex() -> String {
        
        return Data(self.pubKey).toHex()
    }

    public func getBytes() -> [UInt8] {
        
        return self.pubKey
    }
}
