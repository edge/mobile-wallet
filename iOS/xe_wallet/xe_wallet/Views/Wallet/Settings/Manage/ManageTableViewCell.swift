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
        //self.subAdressLabel.text = data.address
        self.walletIconImage.image = UIImage(named:"\(data.type.rawValue)")
        self.addressLabel.text = "\(data.address)"
        
        var amount: Double = 0
        if let status = data.status {
            
            amount = status.balance
        }
        let valString = CryptoHelpers.generateCryptoValueString(value: amount)
        self.amountLabel.text = "\(valString) \(data.type.getDisplayLabel())"
        
        //self.subCreatedLabel.text = DateFunctions.getFormattedDateString(timeSince: Double(data.created))
        //self.subBackedupLabel.text = DateFunctions.getFormattedDateString(timeSince: Double(data.backedup))
    }
    
    @IBAction func backupButtonPressed(_ sender: Any) {
        
        self.delegate?.backupButtonPressed(address: address)
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        
        self.delegate?.removeButtonPressed(address: address)
    }
}
