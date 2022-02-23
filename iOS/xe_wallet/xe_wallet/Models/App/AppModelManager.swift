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
        
        if UserDefaults.standard.object(forKey: "TestMode") == nil {
            
            appData.testMode = true
        } else {
            
            self.appData.testMode = true //UserDefaults.standard.bool(forKey: "TestMode")
        }
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
    
    public func getNetworkStatus() -> NetworkState {
        
        return appData.networkState
    }
    
    
    
    
    func testModeStatus() -> Bool {
        
        return appData.testMode
    }
    
    func testModeToggle() -> Bool {
        
        appData.testMode.toggle()
        UserDefaults.standard.set(appData.testMode, forKey: "TestMode")
        return appData.testMode
    }
    /*
    func getXEServerStatusUrl() -> String {
        
        if self.testModeStatus() == false {
            
            return Constants.XE_MainNetStatusUrl
        }
        
        return Constants.XE_TestNetStatusUrl
    }
    
    func getXEServerSendUrl() -> String {
        
        if self.testModeStatus() == false {
            
            return Constants.XE_MainNetSendUrl
        }
        
        return Constants.XE_TestNetSendUrl
    }
    
    func getXEServerTransactionUrl() -> String {
        
        if self.testModeStatus() == false {
            
            Constants.XE_MainNetTransactionUrl
        }
        
        return Constants.XE_TestNetTransactionUrl
    }
    
    func getXEServerPendingUrl() -> String {
        
        if self.testModeStatus() == false {
            
            Constants.XE_MainNetPendingUrl
        }
        
        return Constants.XE_TestNetPendingUrl
    }
    
    func getNetworkTitleString() -> String {
        
        if self.testModeStatus() == false {
            
            return Constants.XE_networkMainNetTitle
        }
        
        return Constants.XE_networkTestNetTitle
    }
    
    func getNetworkTitleString(status: Bool) -> String {
        
        if status == false {
            
            return Constants.XE_networkMainNetTitle
        }
        
        return Constants.XE_networkTestNetTitle
    }
    
    func getNetworkBridgeString() -> String {
        
        if self.testModeStatus() == false {
            
            return Constants.XE_mainNetBridge
        }
        
        return Constants.XE_testNetBridge
    }*/
}
