//
//  LearnTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 28/01/2022.
//

import UIKit

class EarnTableViewCell: UITableViewCell {
            
    
    @IBOutlet weak var tokenIconImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyLabel: UITextView!
    
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var data111Label: UILabel!
    @IBOutlet weak var data112Label: UILabel!
    @IBOutlet weak var data121Label: UILabel!
    @IBOutlet weak var data122Label: UILabel!
    
    @IBOutlet weak var stackView3: UIStackView!
    
    @IBOutlet weak var data211Label: UILabel!
    @IBOutlet weak var data212Label: UILabel!
    @IBOutlet weak var data221Label: UILabel!
    @IBOutlet weak var data222Label: UILabel!
    @IBOutlet weak var data231Label: UILabel!
    @IBOutlet weak var data232Label: UILabel!
    
    @IBOutlet weak var singleLabelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: EarnSegmentData) {
        
        let padding = self.bodyLabel.textContainer.lineFragmentPadding
        self.bodyLabel.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        
        self.tokenIconImage.image = UIImage(named:data.type.rawValue)
        self.headerLabel.text = data.header
        self.bodyLabel.text = data.body
        
        if data.type == .edge {
            
            self.data212Label.textColor = UIColor(named: "FontSecondary")
            self.data222Label.textColor = UIColor(named: "FontSecondary")
            self.data232Label.textColor = UIColor(named: "FontSecondary")
        } else {
            
            self.data212Label.textColor = UIColor(named: "ButtonGreen")
            self.data222Label.textColor = UIColor(named: "ButtonGreen")
            self.data232Label.textColor = UIColor(named: "ButtonGreen")
        }
        
        if data.data.count == 0 {
            
            self.singleLabelLabel.isHidden = false
            self.stackView2.isHidden = true
            self.stackView3.isHidden = true
        } else if data.data.count == 4 {
          
            self.singleLabelLabel.isHidden = true
            self.stackView2.isHidden = false
            self.stackView3.isHidden = true
            self.data111Label.text = data.data[0]
            self.data112Label.text = data.data[1]
            self.data121Label.text = data.data[2]
            self.data122Label.text = data.data[3]
        } else {
            
            self.singleLabelLabel.isHidden = true
            self.stackView2.isHidden = true
            self.stackView3.isHidden = false
            self.data211Label.text = data.data[0]
            self.data212Label.text = data.data[1]
            self.data221Label.text = data.data[2]
            self.data222Label.text = data.data[3]
            self.data231Label.text = data.data[4]
            self.data232Label.text = data.data[5]
        }
    }
}

