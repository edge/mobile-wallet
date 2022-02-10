//
//  SignalTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 01/02/2022.
//

import UIKit

class SignalTableViewCell: UITableViewCell {
            
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //let padding = self.descriptionTextView.textContainer.lineFragmentPadding
        //self.descriptionTextView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
    
    func configure() {
    }
}
