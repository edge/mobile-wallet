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
        
        self.settingsData.append(SettingsDataModel(type:.header, menuTitle:"ACCOUNT", linkDataType:.header, linkData: ""))
        self.settingsData.append(SettingsDataModel(type:.menuItem, menuTitle:"Manage Wallets", linkDataType:.screen, linkData: "ShowManageViewController"))
        self.settingsData.append(SettingsDataModel(type:.menuItem, menuTitle:"Network", linkDataType:.screen, linkData: "ShowNetworkViewController"))
        self.settingsData.append(SettingsDataModel(type:.header, menuTitle:"INFO", linkDataType:.header, linkData: ""))
        self.settingsData.append(SettingsDataModel(type:.menuItem, menuTitle:"Support", linkDataType:.web, linkData: "https://wiki.edge.network/support/community-guidelines"))
        self.settingsData.append(SettingsDataModel(type:.menuItem, menuTitle:"About", linkDataType:.web, linkData: "https://wiki.edge.network/support/community-guidelines"))
    }
    
    public func getSettingsData() -> [SettingsDataModel] {
        
        return self.settingsData
    }
}
