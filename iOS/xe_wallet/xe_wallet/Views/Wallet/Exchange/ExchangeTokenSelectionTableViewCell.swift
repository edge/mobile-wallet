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
    var abv: String
    var balance: Double
    var value: Double

    enum CodingKeys: String, CodingKey {
        
        case type
        case address
        case abv
        case balance
        case value
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(WalletType.self, forKey: .type)
        self.address = try container.decode(String.self, forKey: .address)
        self.abv = try container.decode(String.self, forKey: .abv)
        self.balance = try container.decode(Double.self, forKey: .balance)
        self.value = try container.decode(Double.self, forKey: .value)
    }
    
    public init(type: WalletType, address: String, abv: String, balance: Double, value: Double) {
        
        self.type = type
        self.address = address
        self.abv = abv
        self.balance = balance
        self.value = value
    }
}

class ExchangeTokenSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tokenImage: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configure() {

    }
}
