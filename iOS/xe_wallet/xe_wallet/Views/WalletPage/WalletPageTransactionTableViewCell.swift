//
//  WalletPageTransactionTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 24/01/2022.
//

import UIKit

class WalletPageTransactionTableViewCell: UITableViewCell {
            
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
        self.typeLabel.text = data.type?.getFullNameLabel()
        
        if data.confirmations ?? 0 >= 10 {
            
            let date = Date(timeIntervalSince1970:TimeInterval(data.timestamp))
            self.receivedLabel.text = date.timeAgoDisplay()
        } else {
            
            self.receivedLabel.text = "Pending"
        }
        self.amountLabel.text = CryptoHelpers.generateCryptoValueString(value: Double(data.amount))

    }
}
