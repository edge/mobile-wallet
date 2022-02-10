//
//  WalletPortfolioTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 14/12/2021.
//

import UIKit

class WalletPortfolioTableViewCell: UITableViewCell {
            
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var networkNameLabel: UILabel!
    
    var updateTimer : Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.updateTimer = Timer.scheduledTimer(withTimeInterval: Constants.XE_GasPriceUpdateTime, repeats: true) { timer in
            
            self.updateTotalValue()
        }
    }
    
    func configure(address: String) {
                
        self.updateTotalValue()
        if let type = WalletDataModelManager.shared.getWalletTypeFromAddress(address: address) {
            
            self.networkLabel.isHidden = false
            self.networkNameLabel.isHidden = false
            if type == .xe {
                
                self.networkNameLabel.text = "XE Testnet"
            } else {
                
                self.networkNameLabel.text = "Rinkeby Testnet"
            }
        } else {
            
            self.networkLabel.isHidden = true
            self.networkNameLabel.isHidden = true
        }
    }
    
    func updateTotalValue() {
        
        let total = WalletDataModelManager.shared.getWalletTotalValue()
        self.totalValue.text = total
    }
}
