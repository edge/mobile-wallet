//
//  TransactionViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 09/10/2021.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
            
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var directionArrowImage: UIImageView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(walletData: WalletDataModel?, transactionData: TransactionRecordDataModel?) {
        
        guard let wallet = walletData else { return }
        guard let transaction = transactionData else { return }
        
        self.typeImageView.image = UIImage(named:wallet.type.rawValue)
        
        if wallet.address.lowercased() == transaction.sender.lowercased() {
            
            self.directionArrowImage.image = UIImage(systemName:"arrow.up")
            self.directionArrowImage.tintColor = UIColor.red
            self.typeLabel.text = transaction.recipient
        } else {
            
            self.directionArrowImage.image = UIImage(systemName:"arrow.down")
            self.directionArrowImage.tintColor = UIColor.green
            self.typeLabel.text = transaction.sender
        }
        
        if transaction.confirmations ?? 0 >= 10 {
            
            self.mainView.alpha = 1.0
            let date = Date(timeIntervalSince1970:TimeInterval(transaction.timestamp))
            self.memoLabel.text = date.timeAgoDisplay()
        } else {
            
            self.mainView.alpha = 0.4
            self.memoLabel.text = "Pending"
        }
        
        self.amountLabel.text = CryptoHelpers.generateCryptoValueString(value: transaction.amount)
    }
}

