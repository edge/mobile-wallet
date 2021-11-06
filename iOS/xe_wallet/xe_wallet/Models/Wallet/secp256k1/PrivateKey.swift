//
//  PrivateKey.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

/// Private key protocol for any asymmetric key algorithm.
public protocol PrivateKey {
    
    /// The algorithm name associated with the PrivateKey.
    static var algorithmName: String { get }

    /**
        Return the PrivateKey, hex encoded.
        - Returns: Hex encoded private key
     */
    func hex() -> String

    /**
        Return the bytes underlying the PrivateKey.
     
        - Returns: Bytes underlying the private key.
    */
    func getBytes() -> [UInt8]

}
