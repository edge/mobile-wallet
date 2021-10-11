//
//  WalletCollectionViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 09/10/2021.
//

import UIKit

class WalletCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var iconCircleView: UIView!
    @IBOutlet weak var walletTypeIcon: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var backupView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.iconCircleView.layer.borderWidth = 2
        self.iconCircleView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func config(data: WalletDataModel) {
        
        self.walletTypeIcon.image = UIImage(named:data.type.rawValue)
        self.addressLabel.text = "xe_A4788d8201Fb879e3b7523a0367401D2a985D42F"
        self.amountLabel.text = "1,303.000000 \(data.type.getDisplayLabel())"
        self.valueLabel.text = "$900 USD"
        
        if data.backedup == true {
            
            self.backupView.isHidden = true
        } else {
            
            self.backupView.isHidden = false
        }
    }
}

