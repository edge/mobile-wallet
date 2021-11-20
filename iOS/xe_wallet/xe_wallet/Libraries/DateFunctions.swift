//
//  DateFunctions.swift
//  xe_wallet
//
//  Created by Paul Davis on 20/11/2021.
//

import UIKit

class DateFunctions {
    
    static func getFormattedDateString(timeSince: Double) -> String {
        
        let dateTimeStamp = NSDate(timeIntervalSince1970:timeSince)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        numberFormatter.locale = Locale.current
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let dayString = dayFormatter.string(from: dateTimeStamp as Date)
        let monthString = monthFormatter.string(from: dateTimeStamp as Date)
        let dayNumber = NSNumber(value: Int(dayString)!)
        let day = numberFormatter.string(from: dayNumber)!
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mma"
        let currentTime = timeFormatter.string(from: dateTimeStamp as Date)

        return ("\(monthString) \(day) at \(currentTime)")
    }
}
