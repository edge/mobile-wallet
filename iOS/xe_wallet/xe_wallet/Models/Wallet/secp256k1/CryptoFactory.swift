//
//  CryptoFactory.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

public class CryptoFactory {
    /// Private constructor for Factory class.
    init() {}

    static func createContext(algorithmName: String) -> Context {
        
        if algorithmName == "secp256k1" {
            
            return Secp256k1Context()
        }
        fatalError(String(format: "Algorithm %@ is not implemented", algorithmName))
    }
}
