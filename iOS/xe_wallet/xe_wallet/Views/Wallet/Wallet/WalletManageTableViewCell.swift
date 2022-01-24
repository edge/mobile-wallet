//
//  WalletManageTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 15/12/2021.
//

import UIKit

class WalletManageTableViewCell: UITableViewCell {
            
    @IBOutlet weak var pageController: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        NotificationCenter.default.addObserver(self, selector: #selector(onSetWalletCardAmount(_:)), name: .setWalletCardAmount, object: nil)
    }
    
    func configure() {
        
    }
    
    @objc func onSetWalletCardAmount(_ notification: Notification) {
        
        if let amount = notification.userInfo?["amount"] as? UIImage {
        }
    }
}
