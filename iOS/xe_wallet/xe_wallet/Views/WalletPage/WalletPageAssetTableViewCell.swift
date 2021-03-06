//
//  WalletPageAssetTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 24/01/2022.
//

import UIKit

class WalletPageAsset {
    
    var type: WalletType = .ethereum
    var tokenType: ERC20TokenType? = .edge
    var amount: Double = 0.0
    var value: Double = 0.0
    
    init(type: WalletType, tokenType: ERC20TokenType?, amount: Double, value: Double) {
        
        self.type = type
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
            
            self.tokenIconImage.image = UIImage(named:data.type.rawValue)
            self.tokenNameLabel.text = data.type.getDataString(dataType: .fullNameLabel)
        }
        
        self.tokenCoinAmountLabel.text = CryptoHelpers.generateCryptoValueString(value: data.amount)
        
        if data.value == 0 || data.tokenType == .usdc {
        
            self.tokenValueLabel.isHidden = true
            self.tokenChangeImage.isHidden = true
            if data.tokenType == .usdc {
            
                self.tokenChangeLabel.text = "$\(StringHelpers.generateValueString(value: data.amount))"
            } else {
                
                self.tokenChangeLabel.text = "$\(StringHelpers.generateValueString(value: data.value))"
            }
        } else {
            
            self.tokenValueLabel.isHidden = false
            self.tokenChangeImage.isHidden = false
            self.tokenValueLabel.text = "$\(StringHelpers.generateValueString(value: data.value))"
            
            let percent = XEExchangeRateHistoryManager.shared.getRateHistoryPercentage(type: data.type)
            self.tokenChangeLabel.text = "\(String(format: "%.2f", Double(percent)))%"
            
            if percent > 0 {
            
                self.tokenChangeLabel.textColor = UIColor(named: "XEGreen")
                self.tokenChangeImage.image = UIImage(named:"trendlineUp")
            } else {
                
                self.tokenChangeLabel.textColor = UIColor(named: "FontSecondary")
                self.tokenChangeImage.image = UIImage(named:"trendlineDown")
            }
        }
    }
}
