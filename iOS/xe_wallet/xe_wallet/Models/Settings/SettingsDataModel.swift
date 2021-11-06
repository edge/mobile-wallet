//
//  SettingsDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import UIKit

enum SettingsCellType: String {
    
    case header = "SettingsHeaderTableViewCell"
    case menuItem = "SettingsMenuItemTableViewCell"
    
    func getHeight() -> CGFloat {
        switch self {
        case .header:
            return 36
        case .menuItem:
            return 66
        }
    }
}

enum SettingsLinkDataType {
    
    case header
    case screen
    case web
}

struct SettingsDataModel {
    
    var type: SettingsCellType
    var menuTitle: String
    var linkDataType: SettingsLinkDataType
    var linkData: String
}
