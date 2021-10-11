//
//  SettingsModelManager.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import Foundation

class SettingsDataModelManager {

    static let shared = SettingsDataModelManager()
    
    var settingsData = [SettingsDataModel]()
    
    private init() {
        
        self.settingsData.append(SettingsDataModel(type:.header, menuTitle:"ACCOUNT"))
        self.settingsData.append(SettingsDataModel(type:.menuItem, menuTitle:"Manage Wallets"))
        self.settingsData.append(SettingsDataModel(type:.header, menuTitle:"INFO"))
        self.settingsData.append(SettingsDataModel(type:.menuItem, menuTitle:"Support"))
        self.settingsData.append(SettingsDataModel(type:.menuItem, menuTitle:"About"))
    }
    
    public func getSettingsData() -> [SettingsDataModel] {
        
        return self.settingsData
    }
}
