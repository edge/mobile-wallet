//
//  Context.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

/// Protocol to be implemented by different signing backends.
public protocol Context {

    /// The algorithm name associated with the type of Context.
    static var algorithmName: String { get }

    /**
        Create a signature by signing the bytes.
     
        - Parameters:
            - data: The bytes being signed.
            - privateKey: Private key of the signer.
        - Returns: Hex encoded signature.
    */
    func sign(data: [UInt8], privateKey: PrivateKey) throws -> String

    /**
        Verify that the private key associated with the public key
        produced the signature by signing the bytes.
     
        - Parameters:
            - signature: The signature being verified.
            - data: The signed data.
            - publicKey: The public key claimed to be associated with the signature.
     
        - Returns: Whether the signer is verified.
    */
    func verify(signature: String, data: [UInt8], publicKey: PublicKey) throws -> Bool

    /**
        Get the public key associated with the private key.
    
        - Parameters:
            - privateKey: Private key associated with the requested public key.
    
        - Returns: Public key associated with the given private key.
     */
    func getPublicKey(privateKey: PrivateKey) throws -> PublicKey

    /**
        Generate a random private key.
     
        - Returns: New private key.
     */
    func newRandomPrivateKey() -> PrivateKey
}
