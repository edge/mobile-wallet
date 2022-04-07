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
        
        let test = UserDefaults.standard.bool(forKey: "TestMode")
        if test {
            
            self.appData.networkState = .test
        } else {
            
            self.appData.networkState = .main
        }
    }
    
    func saveNetworkStatus() {
        
        if self.appData.networkState == .test {
            
            UserDefaults.standard.set(true, forKey: "TestMode")
        } else {
            
            UserDefaults.standard.set(false, forKey: "TestMode")
        }
        UserDefaults.standard.synchronize()
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
    
    public func getNetworkStatusString() -> String {
    
        return appData.networkState.rawValue
    }
    
    
    
    
    
    func testModeStatus() -> NetworkState {
        
        return appData.networkState
    }
    
    func statusToggle() -> Bool {
        
        if self.appData.networkState == .test {
            
            self.appData.networkState = .main
        } else {
            
            self.appData.networkState = .test
        }
        self.saveNetworkStatus()
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
