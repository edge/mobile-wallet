//
//  Secp256k1Error.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

import Foundation

enum SigningError: Error {
    
    case invalidPrivateKey
    case invalidPublicKey
    case invalidSignature
}
