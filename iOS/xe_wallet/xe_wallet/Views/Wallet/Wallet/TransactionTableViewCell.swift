//
//  TransactionViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 09/10/2021.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
            
    @IBOutlet weak var mainView: UIView!
    
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
        self.typeLabel.text = wallet.type.getDisplayLabel()
        
        
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

