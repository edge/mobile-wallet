//
//  UITableView+Ext.swift
//  xe_wallet
//
//  Created by Paul Davis on 18/11/2021.
//

import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Inter-Bold", size: 16)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
