//
//  SettingsHeaderTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import UIKit

class SettingsHeaderTableViewCell: UITableViewCell {
                
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: SettingsDataModel) {

        self.titleLabel.text = data.menuTitle
    }
}
