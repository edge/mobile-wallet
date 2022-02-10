//
//  NSAttributedString+Ext.swift
//  xe_wallet
//
//  Created by Paul Davis on 06/02/2022.
//

import Foundation

extension NSAttributedString {
    
    func replace(placeholder: String, with hyperlink: String, url: String) -> NSAttributedString {
        
        let mutableAttr = NSMutableAttributedString(attributedString: self)

        let hyperlinkAttr = NSAttributedString(string: hyperlink, attributes: [NSAttributedString.Key.link: URL(string: url)!])

        let placeholderRange = (self.string as NSString).range(of: placeholder)

        mutableAttr.replaceCharacters(in: placeholderRange, with: hyperlinkAttr)
        return mutableAttr
    }
}
