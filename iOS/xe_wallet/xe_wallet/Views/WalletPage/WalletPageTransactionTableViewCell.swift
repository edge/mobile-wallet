//
//  WalletPageTransactionTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 24/01/2022.
//

import UIKit

class WalletPageTransactionTableViewCell: UITableViewCell {
            

    @IBOutlet weak var mainContentView: UIView!
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
        
    func configure(data: TransactionDataModel, type: WalletType, address: String) {
        
        self.typeImageView.image = UIImage(named: data.type?.rawValue ?? "")
        
        if address.lowercased() == data.sender.lowercased() {
            
            self.directionArrowImage.image = UIImage(systemName:"arrow.up")
            self.directionArrowImage.tintColor = UIColor.red
            self.typeLabel.text = data.recipient
            self.amountLabel.text = "-\(CryptoHelpers.generateCryptoValueString(value: Double(data.amount)))"
        } else {
            
            self.directionArrowImage.image = UIImage(systemName:"arrow.down")
            self.directionArrowImage.tintColor = UIColor(named:"XEGreen")
            self.typeLabel.text = data.sender
            self.amountLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: Double(data.amount)))"
        }
        
        let date = Date(timeIntervalSince1970:TimeInterval(data.timestamp))
        self.valueLabel.text = date.timeAgoDisplay()
        
        if type == .xe {
            
            self.receivedLabel.isHidden = false
            if data.data?.memo == "" {
                
                self.receivedLabel.text = "None"
                self.receivedLabel.alpha = 0.4
            } else {
            
                self.receivedLabel.text = data.data?.memo
                self.receivedLabel.alpha = 1.0
            }
        } else {
            
            self.receivedLabel.isHidden = false
            if let type = data.type {
            
                self.receivedLabel.text = "$\(type.getDataString(dataType: .coinSymbolLabel))"
            }
        }
        
        if data.status == .pending {
            
            self.contentView.alpha = 0.4
        } else {
            
            self.contentView.alpha = 1.0
        }
    }
}
