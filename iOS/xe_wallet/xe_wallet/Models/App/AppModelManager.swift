//
//  AppModelManager.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation

class AppDataModelManager {

    static let shared = AppDataModelManager()
    
    var appData = AppDataModel()
    
    let appPinCharacterLength = 6
    
    private init() {
        
    }
    
    func setAppPinCode(pin: String) {
        
        self.appData.pinCode = pin
    }
    
    func getAppPinCode()-> String {
        
        return self.appData.pinCode
    }
    
    func checkPinCode(code: String) -> Bool {
        
        if code == self.appData.pinCode {
            
            return true
        }
        return false
    }
    
    func testModeStatus() -> Bool {
        
        return appData.testMode
    }
    
    func testModeToggle() -> Bool {
        
        appData.testMode.toggle()
        return appData.testMode
    }
    
    func getXEServerStatusUrl() -> String {
        
        if self.testModeStatus() == false {
            
            return self.appData.XE_MainNetStatusUrl
        }
        
        return self.appData.XE_TestNetStatusUrl
    }
    
    func getXEServerTransactionUrl() -> String {
        
        if self.testModeStatus() == false {
            
            return self.appData.XE_MainNetTransactionUrl
        }
        
        return self.appData.XE_TestNetTransactionUrl
    }
    
    func getNetworkTitleString() -> String {
        
        if self.testModeStatus() == false {
            
            return self.appData.XE_networkMainNetTitle
        }
        
        return self.appData.XE_networkTestNetTitle
    }
}
