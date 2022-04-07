//
//  BiometricsManager.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import  UIKit
import  LocalAuthentication

enum BioError: Error {
    
    case General
    case NoEvaluate
}

protocol LAContextProtocol {
    
    func canEvaluatePolicy(_ : LAPolicy, error: NSErrorPointer) -> Bool
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)
}

extension LAContext: LAContextProtocol{}

class BiometricsManager {
    
    let context: LAContextProtocol
    
    init(context: LAContextProtocol = LAContext() ) {
        
        self.context = context
    }
    
    func canEvaluatePolicy() -> Bool {
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
   
    func authenticateUser(completion: @escaping (Result<String, Error>) -> Void) {
        
        guard canEvaluatePolicy() else {
            
            completion( .failure(BioError.NoEvaluate) )
            return
        }
        
        let loginReason = "Log in with Biometrics"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            if success {
                
                DispatchQueue.main.async {
                    // User authenticated successfully
                    completion(.success("Success"))
                }
            } else {
                
                switch evaluateError {
                default: completion(.failure(BioError.General))
                }
            }
        }
    }
}
