//
//  ExchangeWalletCellView.swift
//  xe_wallet
//
//  Created by Paul Davis on 03/01/2022.
//

import UIKit

class ExchangeWalletCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var cardBackgroundImage: UIImageView!
    @IBOutlet weak var coinIconImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var cardValueLabel: UILabel!
    @IBOutlet weak var entryTokenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    

    
    public func config(data: WalletDataModel) {
        
        self.cardBackgroundImage.image = UIImage(named:data.type.getBackgroundImage())
        if self.coinIconImage != nil {
        
            self.coinIconImage.image = UIImage(named:data.type.rawValue)
        }
        self.addressLabel.text = data.address

        var typeSymbol = WalletType.xe.getCoinSymbol()
        if data.type != .xe {
            
            typeSymbol = WalletType.edge.getCoinSymbol()
        }
        
        
        if self.entryTokenLabel != nil {

            self.entryTokenLabel.text = typeSymbol
        }
        
        if self.cardValueLabel != nil {

            self.cardValueLabel.text = "0.0 \(typeSymbol)"
        }
    }
}

