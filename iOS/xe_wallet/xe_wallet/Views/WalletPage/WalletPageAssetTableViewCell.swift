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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: WalletPageAsset) {
                
        self.tokenIconImage.image = UIImage(named:data.type.rawValue)
        self.tokenNameLabel.text = data.type.getFullNameLabel()
        self.tokenAmountLabel.text = CryptoHelpers.generateCryptoValueString(value: data.amount)
        self.tokenValueLabel.text = String(format:"$%.2f", data.value)
        
        let percent = XEExchangeRateHistoryManager.shared.getRateHistoryPercentage(type: data.type)
        self.tokenChangeLabel.text = "\(String(format: "%.2f", Double(percent)))%"
        self.tokenChangeImage.image = XEExchangeRateHistoryManager.shared.getRatePerformanceImage(type: data.type)
    }
}
