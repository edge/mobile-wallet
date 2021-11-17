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
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var backupView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconCircleView.layer.cornerRadius = self.iconCircleView.frame.height / 2
        self.iconCircleView.layer.borderWidth = 2
        self.iconCircleView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    public func config(data: WalletDataModel) {
        
        self.walletTypeIcon.image = UIImage(named:data.type.rawValue)
        self.addressLabel.text = data.address
        
        var amount = 0
        var value = "$0 USD"
        
        if let status = data.status {
            
            amount = status.balance
        }
        
        self.amountLabel.text = "\(String(format: "%.6f", Double(amount/1000000))) \(data.type.getDisplayLabel())"
        self.valueLabel.text = value
    }
    
    public func getCardViewImage() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: self.cardView.bounds.size)
        let image = renderer.image { ctx in
            
            self.cardView.drawHierarchy(in: self.cardView.bounds, afterScreenUpdates: true)
        }
        return image
    }
}

