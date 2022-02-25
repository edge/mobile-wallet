//
//  WalletPageTransactionTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 24/01/2022.
//

import UIKit

class WalletPageTransactionTableViewCell: UITableViewCell {
            
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var directionArrowImage: UIImageView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var receivedLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: TransactionRecordDataModel, type: WalletType, address: String) {
        
        self.typeImageView.image = UIImage(named: data.type?.rawValue ?? "")
        
        if address.lowercased() == data.sender.lowercased() {
            
            self.directionArrowImage.image = UIImage(systemName:"arrow.up")
            self.directionArrowImage.tintColor = UIColor.red
            self.typeLabel.text = data.recipient
        } else {
            
            self.directionArrowImage.image = UIImage(systemName:"arrow.down")
            self.directionArrowImage.tintColor = UIColor.green
            self.typeLabel.text = data.sender
        }
        
        let date = Date(timeIntervalSince1970:TimeInterval(data.timestamp))
        self.valueLabel.text = date.timeAgoDisplay()
        
        if type == .xe {
            
            self.receivedLabel.isHidden = false
            self.receivedLabel.text = data.data?.memo
        } else {
            
            self.receivedLabel.isHidden = true
        }
        
        /*
        if data.confirmations ?? 0 >= 10 {
            
            self.mainView.alpha = 1.0

        } else {
            
            self.mainView.alpha = 0.4
            self.receivedLabel.text = "Pending"
        }*/
        self.amountLabel.text = CryptoHelpers.generateCryptoValueString(value: Double(data.amount))

    }
}
