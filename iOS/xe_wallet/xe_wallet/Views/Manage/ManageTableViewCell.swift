//
//  ManageTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 12/10/2021.
//

import UIKit

class ManageTableViewCell: UITableViewCell {
                
    @IBOutlet weak var walletIconView: UIView!
    @IBOutlet weak var walletIconImage: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.walletIconView.layer.borderWidth = 2
        //self.walletIconView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func configure(data: WalletDataModel) {

        self.walletIconImage.image = UIImage(named:"\(data.type.rawValue)")
        self.addressLabel.text = "\(data.address)"
        self.amountLabel.text = "1.000000 XE"
    }
}
