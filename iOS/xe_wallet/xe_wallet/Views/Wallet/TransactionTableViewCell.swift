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
    
    @IBOutlet weak var sumTxHashLabel: UILabel!
    @IBOutlet weak var sumDateLabel: UILabel!
    @IBOutlet weak var sumAaddressLabel: UILabel!
    @IBOutlet weak var sumMemoLabel: UILabel!
    @IBOutlet weak var sumStatusLabel: UILabel!
    @IBOutlet weak var sumAmountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: TransactionRecordDataModel, address: String) {
        
        var typeLabel = "Sent"
        var iconName = "send"
        if address == data.recipient {
            
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
        
        //Double(0.123456789).roundToPlaces(4)
        
        
        self.amountLabel.text = "\(String(format: "%.6f", Double(data.amount)/1000000))"
        //self.statusLabel.text = "\(data.status.rawValue)"
        
        self.sumTxHashLabel.text = data.hash
        self.sumDateLabel.text = "\(DateFunctions.getFormattedDateString(timeSince: Double(data.timestamp)/1000))"
        self.sumAaddressLabel.text = data.sender
        self.sumMemoLabel.text = memo
        //self.sumStatusLabel.text = "\(data.status.rawValue)"
        self.sumAmountLabel.text = "\(String(format: "%.6f", Double(data.amount)/1000000))"
    }
}

