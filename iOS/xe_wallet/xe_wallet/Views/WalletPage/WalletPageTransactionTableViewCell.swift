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
    
    func configure(data: TransactionRecordDataModel, type: WalletType) {
        
        self.typeImageView.image = UIImage(named: data.type?.rawValue ?? "")
        self.typeLabel.text = data.type?.getFullNameLabel()
        let date = Date(timeIntervalSince1970:TimeInterval(data.timestamp))
        self.receivedLabel.text = date.timeAgoDisplay()
        self.amountLabel.text = CryptoHelpers.generateCryptoValueString(value: Double(data.amount))
        
        
        
        /*var typeLabel = "Sent"
        var iconName = "send"
        if address.lowercased() == data.recipient.lowercased() {
            
            typeLabel = "Received"
            iconName = "receive"
        }
        self.typeLabel.text = typeLabel
        self.typeImageView.image = UIImage(named:iconName)
        
        var memo = ""
        if let memData = data.data {
            
            memo = memData.memo
        }
        self.memoLabel.text = memo
        
        if let status = data.status {
            
            self.statusLabel.text = status.rawValue
        } else {
            
            self.statusLabel.text = TransactionStatus.confirmed.rawValu
        }

        let valString = CryptoHelpers.generateCryptoValueString(value: Double(data.amount))
        self.amountLabel.text = "\(valString)"
        //self.statusLabel.text = "\(data.status.rawValue)"
        */
    }
}
