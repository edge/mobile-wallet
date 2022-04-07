//
//  UITabBar+Ext.swift
//  xe_wallet
//
//  Created by Paul Davis on 25/01/2022.
//

import UIKit

extension UITabBar {

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 171
        return sizeThatFits
    }
}

class CustomTabBar : UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 90
        return sizeThatFits
    }
}
