//
//  CryptoValue.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/11/2021.
//

import UIKit

class CryptoHelpers {
    
    static func generateCryptoValueString(value: Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 6
        formatter.maximumFractionDigits = 6
        let amountVal = Double(value)
        return "\(formatter.string(from:NSNumber(value:amountVal )) ?? "0.000000")"
    }
    
    static func generateCryptoValueStringWithType(value: Double, cryptoString: String) -> String {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 6
        formatter.maximumFractionDigits = 6
        let amountVal = Double(value)
        return "\(formatter.string(from:NSNumber(value:amountVal )) ?? "0.000000") \(cryptoString)"
    }
}
