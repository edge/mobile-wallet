//
//  ExchangeTokenSelectionTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 16/02/2022.
//

import UIKit

class ExchangeTokenSelectionDataModel {
    
    var type: WalletType
    var address: String
    var balance: Double

    enum CodingKeys: String, CodingKey {
        
        case type
        case address
        case balance
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(WalletType.self, forKey: .type)
        self.address = try container.decode(String.self, forKey: .address)
        self.balance = try container.decode(Double.self, forKey: .balance)
    }
    
    public init(type: WalletType, address: String, balance: Double) {
        
        self.type = type
        self.address = address
        self.balance = balance
    }
}

class ExchangeTokenSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configure() {

    }
}
