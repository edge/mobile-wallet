//
//  LearnHeaderTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 02/02/2022.
//

import UIKit

class LearnHeaderTableViewCell: UITableViewCell {
            
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: LearnTableData) {
        
        self.titleLabel.text = data.title
    }
}

