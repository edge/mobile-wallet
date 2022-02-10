//
//  TransactionViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 09/10/2021.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
            
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    /*@IBOutlet weak var sumTxHashLabel: UILabel!
    @IBOutlet weak var sumDateLabel: UILabel!
    @IBOutlet weak var sumAaddressLabel: UILabel!
    @IBOutlet weak var sumMemoLabel: UILabel!
    @IBOutlet weak var sumStatusLabel: UILabel!
    @IBOutlet weak var sumAmountLabel: UILabel!*/
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(walletData: WalletDataModel?, transactionData: TransactionRecordDataModel?) {
        
        guard let wallet = walletData else { return }
        guard let transaction = transactionData else { return }
        
        self.typeImageView.image = UIImage(named:wallet.type.rawValue)
        self.typeLabel.text = wallet.type.getDisplayLabel()
        
        let date = Date(timeIntervalSince1970:TimeInterval(transaction.timestamp))
        self.memoLabel.text = date.timeAgoDisplay()
        
        self.amountLabel.text = CryptoHelpers.generateCryptoValueString(value: transaction.amount)
    }
}

