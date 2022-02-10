//
//  WalletMenuItemTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 28/01/2022.
//

import UIKit

class WalletMenuItemTableViewCell: UITableViewCell {
                
    @IBOutlet weak var itemIconImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: String) {
        
        self.itemTitleLabel.text = data
        if data == "Settings" {
            
            self.itemIconImage.image = UIImage(named:"settings")
        } else if data == "Earn" {
            
            self.itemIconImage.image = UIImage(named:"Seedling")
        } else if data == "Signal" {
            
            self.itemIconImage.image = UIImage(named:"Signal2")
        } else if data == "Learn" {
            
            self.itemIconImage.image = UIImage(named:"airhat")
        }
    }
}
