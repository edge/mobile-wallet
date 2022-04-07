//
//  PublicKey.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

public protocol PublicKey {
    
    static var algorithmName: String { get }

    /**
     Return the PublicKey, hex encoded.
     
     - Returns: Hex encoded private key
     */
    func hex() -> String

    /**
     Return the bytes underlying the PublicKey.
     
     - Returns: Bytes underlying the private key.
     */
    func getBytes() -> [UInt8]
}
