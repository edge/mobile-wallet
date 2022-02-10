//
//  LearnDisclaimerTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 02/02/2022.
//

import UIKit

class LearnDisclaimerTableViewCell: UITableViewCell {
            
    @IBOutlet weak var disclaimerTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let padding = self.disclaimerTextView.textContainer.lineFragmentPadding
        self.disclaimerTextView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
    
    func configure() {

        
        
        
        /*let attributedString = NSMutableAttributedString(string: "Just click here to register")
        let url = URL(string: "https://www.apple.com")!

        attributedString.setAttributes([.link: url], range: NSMakeRange(5, 10))

        self.disclaimerTextView.attributedText = attributedString
        self.disclaimerTextView.isUserInteractionEnabled = true
        self.disclaimerTextView.isEditable = false

        self.disclaimerTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]*/
    }
}
