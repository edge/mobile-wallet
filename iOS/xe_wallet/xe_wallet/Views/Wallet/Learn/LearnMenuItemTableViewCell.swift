//
//  LearnMenuItemTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 02/02/2022.
//

import UIKit

class LearnMenuItemTableViewCell: UITableViewCell {
                
    @IBOutlet weak var itemIconImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: LearnTableData) {
        
        self.itemIconImage.image = UIImage(named:data.image)
        self.itemTitleLabel.text = data.title
    }
}
