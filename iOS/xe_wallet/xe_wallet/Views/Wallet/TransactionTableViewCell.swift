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
    
    func configure(data: TransactionRecordDataModel) {
        
        self.typeImageView.image = UIImage(named:data.type.getImageName())

        self.typeLabel.text = "\(data.type.rawValue)"
        self.memoLabel.text = "Memo"
        self.amountLabel.text = "\(data.amount)"
        self.statusLabel.text = "\(data.status.rawValue)"
        
        self.sumTxHashLabel.text = "hash number"
        self.sumDateLabel.text = "Confirmed - Sept 12th at 9:34am"
        self.sumAaddressLabel.text = "xe_1239487skjfhsmd"
        self.sumMemoLabel.text = "testing"
        self.sumStatusLabel.text = "\(data.status.rawValue)"
        self.sumAmountLabel.text = "\(data.amount)"
    }
}

