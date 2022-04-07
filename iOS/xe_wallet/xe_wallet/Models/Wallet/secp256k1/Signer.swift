//
//  Signer.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

/// Convenience class that wraps the PrivateKey and Context
public class Signer {
    
    var context: Context
    var privateKey: PrivateKey

    public init(context: Context, privateKey: PrivateKey) {
        
        self.context = context
        self.privateKey = privateKey
    }

    /**
        Produce a hex encoded signature from the data and the private key.
         - Parameters:
            - data: The bytes being signed.
         - Returns: Hex encoded signature.
    */
    public func sign(data: [UInt8]) throws -> String {
        
        return try self.context.sign(data: data, privateKey: self.privateKey)
    }

    /**
        Get the public key associated with the private key.
        - Returns: Public key associated with the signer's private key.
     */
    public func getPublicKey() throws -> PublicKey {
        
        return try self.context.getPublicKey(privateKey: self.privateKey)
    }
}
