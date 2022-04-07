//
//  Date+Ext.swift
//  xe_wallet
//
//  Created by Paul Davis on 28/01/2022.
//

import Foundation

extension Date {
    
    func timeAgoDisplay(ago: String) -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) secs \(ago)"
        } else if hourAgo < self {
            
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            if diff == 1 {
                
                return "\(diff) min \(ago)"
            }
            return "\(diff) mins \(ago)"
        } else if dayAgo < self {
            
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            if diff == 1 {
                
                return "\(diff) hour \(ago)"
            }
            return "\(diff) hours \(ago)"
        } else if weekAgo < self {
            
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff == 1 {
                
                return "\(diff) day \(ago)"
            }
            return "\(diff) days \(ago)"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        if diff == 1 {
            
            return "\(diff) week \(ago)"
        }
        return "\(diff) weeks \(ago)"
    }
    
    func getFormattedDate(format: String) -> String {
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
