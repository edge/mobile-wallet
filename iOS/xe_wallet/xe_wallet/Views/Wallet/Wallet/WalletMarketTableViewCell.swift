//
//  WalletMarketTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/01/2022.
//

import UIKit

class WalletMarketTableViewCell: UITableViewCell {
            
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenNameLabel: UILabel!
    @IBOutlet weak var tokenAbvLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: String) {
        
        var type: WalletType = .edge
        if data == "Ethereum" {
            
            type = .ethereum
        }
        
        self.tokenImage.image = UIImage(named:type.rawValue)
        self.tokenNameLabel.text = type.getFullNameLabel()
        self.tokenAbvLabel.text = type.getCoinSymbol()
    }
}
