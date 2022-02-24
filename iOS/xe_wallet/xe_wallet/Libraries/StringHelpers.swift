//
//  StringHelpers.swift
//  xe_wallet
//
//  Created by Paul Davis on 21/02/2022.
//

import Foundation

class StringHelpers {
    
    static func generateValueString(value: Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let amountVal = Double(value)
        return "\(formatter.string(from:NSNumber(value:amountVal )) ?? "0.00")"
    }
    
    static func generateValueString4Dec(value: Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 4
        formatter.maximumFractionDigits = 4
        let amountVal = Double(value)
        return "\(formatter.string(from:NSNumber(value:amountVal )) ?? "0.00")"
    }
}
