//
//  ManageTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 12/10/2021.
//

import UIKit

@objc public protocol ManageTableViewCellDelegate: AnyObject {
    
    func backupButtonPressed(address: String)
    func removeButtonPressed(address: String)
}

class ManageTableViewCell: UITableViewCell {
                
    @IBOutlet weak var walletIconView: UIView!
    @IBOutlet weak var walletIconImage: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var subAdressLabel: UILabel!
    @IBOutlet weak var subCreatedLabel: UILabel!
    @IBOutlet weak var subBackedupLabel: UILabel!
    
    var delegate: ManageTableViewCellDelegate?
    
    var address: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configure(data: WalletDataModel) {

        self.address = data.address
        self.subAdressLabel.text = data.address
        self.walletIconImage.image = UIImage(named:"\(data.type.rawValue)")
        self.addressLabel.text = "\(data.address)"
        self.amountLabel.text = "1.000000 XE"
        
        self.subCreatedLabel.text = self.getFormattedDateString(timeSince: Double(data.created))
        self.subBackedupLabel.text = self.getFormattedDateString(timeSince: Double(data.backedup))
    }
    
    @IBAction func backupButtonPressed(_ sender: Any) {
        
        self.delegate?.backupButtonPressed(address: address)
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        
        self.delegate?.removeButtonPressed(address: address)
    }
    
    func getFormattedDateString(timeSince: Double) -> String {
        
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
