//
//  Secp256k1PrivateKey.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

import UIKit

public class Secp256k1PrivateKey: PrivateKey {
    
    public static var algorithmName = "secp256k1"
    let privKey: [UInt8]

    init(privKey: [UInt8]) {
        
        self.privKey = privKey
    }

    public static func fromHex(hexPrivKey: String) -> Secp256k1PrivateKey {
        
        return Secp256k1PrivateKey(privKey: hexPrivKey.toBytes)
    }

    public func hex() -> String {
        
        return Data(self.privKey).toHex()
    }

    public func getBytes() -> [UInt8] {
        
        return self.privKey
    }
}
