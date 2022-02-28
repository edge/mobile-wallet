//
//  WalletPageAssetTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 24/01/2022.
//

import UIKit

class WalletPageAsset {
    
    var walletType: WalletType = .ethereum
    var tokenType: ERC20TokenType? = .edge
    var amount: Double = 0.0
    var value: Double = 0.0
    
    init(walletType: WalletType, tokenType: ERC20TokenType?, amount: Double, value: Double) {
        
        self.walletType = walletType
        self.tokenType = tokenType
        self.amount = amount
        self.value = value
    }
}

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
                
        if let tokenType = data.tokenType {
            
            self.tokenIconImage.image = UIImage(named:tokenType.rawValue)
            self.tokenNameLabel.text = tokenType.getFullNameLabel()
        } else {
            
            self.tokenIconImage.image = UIImage(named:data.walletType.rawValue)
            self.tokenNameLabel.text = data.walletType.getDataString(dataType: .fullNameLabel)
        }
        
        self.tokenCoinAmountLabel.text = CryptoHelpers.generateCryptoValueString(value: data.amount)
        
        if data.value == 0 {
        
            self.tokenValueLabel.isHidden = true
            self.tokenChangeImage.isHidden = true
            self.tokenChangeLabel.text = String(format:"$%.2f", data.value)
        } else {
            
            self.tokenValueLabel.isHidden = false
            self.tokenChangeImage.isHidden = false
            self.tokenValueLabel.text = String(format:"$%.2f", data.value)
            
            let percent = XEExchangeRateHistoryManager.shared.getRateHistoryPercentage(type: data.walletType)
            self.tokenChangeLabel.text = "\(String(format: "%.2f", Double(percent)))%"
            self.tokenChangeImage.image = XEExchangeRateHistoryManager.shared.getRatePerformanceImage(type: data.walletType)
        }
    }
}
