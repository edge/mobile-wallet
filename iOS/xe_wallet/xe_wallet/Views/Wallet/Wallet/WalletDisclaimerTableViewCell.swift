//
//  WalletDisclaimerTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/01/2022.
//

import UIKit

class WalletDisclaimerTableViewCell: UITableViewCell {
            
    @IBOutlet weak var disclaimerTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let padding = self.disclaimerTextView.textContainer.lineFragmentPadding
        self.disclaimerTextView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
    
    func configure() {

    }
}

