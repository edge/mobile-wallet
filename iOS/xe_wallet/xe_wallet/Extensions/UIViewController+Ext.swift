//
//  UIViewController+Ext.swift
//  xe_wallet
//
//  Created by Paul Davis on 20/11/2021.
//

import UIKit

var vSpinner : UIView?

extension UIViewController {
    
    func showSpinner(onView : UIView) {
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.color = .white
        ai.startAnimating()
        ai.center = spinnerView.center
        
        //DispatchQueue.main.async {
            
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        //}
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        
        DispatchQueue.main.async {
            
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
