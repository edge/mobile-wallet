//
//  UITableView+Ext.swift
//  xe_wallet
//
//  Created by Paul Davis on 18/11/2021.
//

import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        
        let backView = UIView(frame: CGRect(x: 0, y:0, width: self.bounds.size.width, height: self.bounds.size.height))
        backView.backgroundColor = UIColor(named:"BackgroundMain")
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y:0, width: self.bounds.size.width, height: 20))
        messageLabel.text = message
        messageLabel.textColor = UIColor(named: "FontSecondary")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Inter-Regular", size: 16)
        messageLabel.sizeToFit()
        messageLabel.baselineAdjustment = .alignCenters
        messageLabel.center.x = backView.center.x
        messageLabel.center.y = backView.center.y - 24
        backView.addSubview(messageLabel)
        
        self.backgroundView = backView
        self.separatorStyle = .none
    }

    func restore() {
        
        if let backview = self.backgroundView {
            for view in backview.subviews{
                
                view.removeFromSuperview()
            }
        }
        
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
