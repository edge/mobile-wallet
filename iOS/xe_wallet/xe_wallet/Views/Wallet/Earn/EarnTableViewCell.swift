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
    
    @IBOutlet weak var data11Label: UILabel!
    @IBOutlet weak var data12Label: UILabel!
    
    @IBOutlet weak var data21Label: UILabel!
    @IBOutlet weak var data22Label: UILabel!
    
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
        self.data11Label.text = data.data11
        self.data12Label.text = data.data12
        self.data21Label.text = data.data21
        self.data22Label.text = data.data22
    }
}

