//
//  UIRefreshControl+Ext.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/02/2022.
//

import UIKit

extension UIRefreshControl {
    
    func beginRefreshingManually() {
        
        if let scrollView = superview as? UIScrollView {
            
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
    }
}
