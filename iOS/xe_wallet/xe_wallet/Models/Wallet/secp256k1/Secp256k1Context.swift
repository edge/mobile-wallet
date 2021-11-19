//
//  Secp256k1Context.swift
//  xe_wallet
//
//  Created by Paul Davis on 31/10/2021.
//

import UIKit
import secp256k1
import Security
import libsecp256k1


/// A Context for signing and verifying secp256k1 signatures.
public class Secp256k1Context: Context {
    
    public init() {}

    public static var algorithmName = "secp256k1"

    public func sign(data: [UInt8], privateKey: PrivateKey) throws -> String {
        
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))
        var sig = secp256k1_ecdsa_signature()
    
        var msgDigest = hash(data: data)
        var resultSign = msgDigest.withUnsafeMutableBytes { (msgDigestBytes) in
            
            secp256k1_ecdsa_sign(ctx!, &sig, msgDigestBytes, privateKey.getBytes(), nil, nil)
        }
        if resultSign == 0 {
            
            throw SigningError.invalidPrivateKey
        }

        var input: [UInt8] {
            
            var tmp = sig.data
            return [UInt8](UnsafeBufferPointer(start: &tmp.0, count: MemoryLayout.size(ofValue: tmp)))
        }
        var compactSig = secp256k1_ecdsa_signature()

        if secp256k1_ecdsa_signature_parse_compact(ctx!, &compactSig, input) == 0 {
            
            secp256k1_context_destroy(ctx)
            throw SigningError.invalidSignature
        }

        var csigArray: [UInt8] {
            
            var tmp = compactSig.data
            return [UInt8](UnsafeBufferPointer(start: &tmp.0, count: MemoryLayout.size(ofValue: tmp)))
        }

        secp256k1_context_destroy(ctx)
        return Data(csigArray).toHex()
    }
    
    public func sign_recoverable(data: [UInt8], privateKey: PrivateKey) throws -> String {
        
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))
        var sig = secp256k1_ecdsa_recoverable_signature()
    
        
        var msgDigest = hash(data: data)
        var resultSign = msgDigest.withUnsafeMutableBytes { (msgDigestBytes) in
            
            secp256k1_ecdsa_sign_recoverable(ctx!, &sig, msgDigestBytes, privateKey.getBytes(), nil, nil)
        }
        
        if resultSign == 0 {
            
            throw SigningError.invalidPrivateKey
        }

        var input: [UInt8] {
            
            var tmp = sig.data
            return [UInt8](UnsafeBufferPointer(start: &tmp.0, count: MemoryLayout.size(ofValue: tmp)))
        }
        var compactSig = secp256k1_ecdsa_recoverable_signature()

        var recid: Int32 = 1
        
        if secp256k1_ecdsa_recoverable_signature_parse_compact(ctx!, &compactSig, input, recid) == 0 {
            
            secp256k1_context_destroy(ctx)
            throw SigningError.invalidSignature
        }

        var csigArray: [UInt8] {
            
            var tmp = compactSig.data
            return [UInt8](UnsafeBufferPointer(start: &tmp.0, count: MemoryLayout.size(ofValue: tmp)))
        }

        secp256k1_context_destroy(ctx)
        return Data(csigArray).toHex()
    }
    
    public func verify(signature: String, data: [UInt8], publicKey: PublicKey) throws-> Bool {
        
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY))

        var sig = secp256k1_ecdsa_signature()
        if secp256k1_ecdsa_signature_parse_compact(ctx!, &sig, signature.toBytes) == 0 {
            
            secp256k1_context_destroy(ctx)
            throw SigningError.invalidSignature
        }

        var pubKey = secp256k1_pubkey()
        let resultParsePublicKey = secp256k1_ec_pubkey_parse(ctx!, &pubKey, publicKey.getBytes(),
                                                             publicKey.getBytes().count)
        if resultParsePublicKey == 0 {
            
             throw SigningError.invalidPublicKey
        }

        let msgDigest = hash(data: data)
        let result = msgDigest.withUnsafeBytes { (msgDigestBytes) -> Int32 in
            
            return secp256k1_ecdsa_verify(ctx!, &sig, msgDigestBytes, &pubKey)
        }

        secp256k1_context_destroy(ctx)

        if result == 1 {
            
            return true
        } else {
            
            return false
        }
    }

    /*public func getPublicKey(privateKey: PrivateKey) throws -> PublicKey {
        
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))
        var pubKey = secp256k1_pubkey()

        if secp256k1_ec_pubkey_create(ctx!, &pubKey, privateKey.getBytes()) == 0 {
            
            secp256k1_context_destroy(ctx)
            throw SigningError.invalidPrivateKey
        }

        var pubKeyBytes = [UInt8](repeating: 0, count: 33)
        var outputLen = 33
        _ = secp256k1_ec_pubkey_serialize(
            ctx!, &pubKeyBytes, &outputLen, &pubKey, UInt32(SECP256K1_EC_UNCOMPRESSED))

        secp256k1_context_destroy(ctx)
        return Secp256k1PublicKey(pubKey: pubKeyBytes)
    }*/
    
    public func getPublicKey(privateKey: PrivateKey) throws -> PublicKey {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))
        var pubKey = secp256k1_pubkey()

        if secp256k1_ec_pubkey_create(ctx!, &pubKey, privateKey.getBytes()) == 0 {
            secp256k1_context_destroy(ctx)
            throw SigningError.invalidPrivateKey
        }

        var pubKeyBytes = [UInt8](repeating: 0, count: 33)
        var outputLen = 33
        _ = secp256k1_ec_pubkey_serialize(
            ctx!, &pubKeyBytes, &outputLen, &pubKey, UInt32(SECP256K1_EC_COMPRESSED))

        secp256k1_context_destroy(ctx)
        return Secp256k1PublicKey(pubKey: pubKeyBytes)
    }

    public func newRandomPrivateKey() -> PrivateKey {
        
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))
        let bytesCount = 32
        var randomBytes: [UInt8] = [UInt8](repeating: 0, count: bytesCount)

        repeat {
            
            _ = SecRandomCopyBytes(kSecRandomDefault, bytesCount, &randomBytes)
        } while secp256k1_ec_seckey_verify(ctx!, &randomBytes) != Int32(1)

        secp256k1_context_destroy(ctx)
        return Secp256k1PrivateKey(privKey: randomBytes)
    }
}
