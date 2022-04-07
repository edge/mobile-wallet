//
//  UIView+Nib.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit

extension UIView {

    static func loadFromNib() -> Self {
        
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
}
