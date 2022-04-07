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

        
        //Set through code or through interface builder
        self.disclaimerTextView.isSelectable = true
        self.disclaimerTextView.dataDetectorTypes = .link

        //Keeps the original formatting from xib or storyboard
        self.disclaimerTextView.text = "Please be aware that while we endeavour to answer inbound emails as quickly as possible, it may take some time for the team to reply.  You can access the Source Code for this app on GitHub at: https://github.com/edge/mobile-wallet  Community contributions welcome."
        self.disclaimerTextView.attributedText = self.disclaimerTextView.attributedText?
                .replace(placeholder: "https://github.com/edge/mobile-wallet", with: "https://github.com/edge/mobile-wallet", url: "https://github.com/edge/mobile-wallet")
                
        
        
        
        
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
