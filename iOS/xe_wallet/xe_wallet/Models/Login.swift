//
//  Login.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import Foundation

class LoginDataModelManager {

    static let shared = LoginDataModelManager()
    
    var loginAttempts = 0
        
    private init() {
        
        self.loginAttempts = 0
    }
    
    func increaseLoginAttemts() {
        
        self.loginAttempts += 1
    }

}
