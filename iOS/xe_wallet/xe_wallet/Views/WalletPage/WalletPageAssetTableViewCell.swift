//
//  WalletPageAssetTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 24/01/2022.
//

import UIKit

class WalletPageAssetTableViewCell: UITableViewCell {
            
    @IBOutlet weak var tokenIconImage: UIImageView!
    @IBOutlet weak var tokenNameLabel: UILabel!
    @IBOutlet weak var tokenAmountLabel: UILabel!
    @IBOutlet weak var tokenValueLabel: UILabel!
    @IBOutlet weak var tokenChangeLabel: UILabel!
    @IBOutlet weak var tokenChangeImage: UIImageView!
    @IBOutlet weak var tokenCoinAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: WalletPageAsset) {
                
        self.tokenIconImage.image = UIImage(named:data.type.rawValue)
        self.tokenNameLabel.text = data.type.getFullNameLabel()
        self.tokenCoinAmountLabel.text = CryptoHelpers.generateCryptoValueString(value: data.amount)
        
        if data.value == 0 {
        
            self.tokenValueLabel.isHidden = true
            self.tokenChangeImage.isHidden = true
            self.tokenChangeLabel.text = String(format:"$%.2f", data.value)
        } else {
            
            self.tokenValueLabel.isHidden = false
            self.tokenChangeImage.isHidden = false
            self.tokenValueLabel.text = String(format:"$%.2f", data.value)
            
            let percent = XEExchangeRateHistoryManager.shared.getRateHistoryPercentage(type: data.type)
            self.tokenChangeLabel.text = "\(String(format: "%.2f", Double(percent)))%"
            self.tokenChangeImage.image = XEExchangeRateHistoryManager.shared.getRatePerformanceImage(type: data.type)
        }
    }
}
