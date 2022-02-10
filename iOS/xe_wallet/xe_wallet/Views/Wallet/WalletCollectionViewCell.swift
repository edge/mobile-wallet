//
//  WalletCollectionViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 09/10/2021.
//

import UIKit

class WalletCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var iconCircleView: UIView!
    @IBOutlet weak var walletTypeIcon: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var creditCardImage: UIImageView!
    
    @IBOutlet weak var balanaceStringLabel: UILabel!
    @IBOutlet weak var edgeView: UIView!
    @IBOutlet weak var edgeAmountLabel: UILabel!
    @IBOutlet weak var edgeTotalLabel: UILabel!
    
    
    @IBOutlet weak var backupView: UIView!
    
    var timerExchange: Timer?
    
    var walletData: WalletDataModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.timerExchange?.invalidate()
    }
    
    deinit {

        if let timer = self.timerExchange {
        
            timer.invalidate()
            self.timerExchange = nil
        }
    }
    
    public func config(data: WalletDataModel) {
        
        self.walletData = data

        self.displayCellData()
        self.timerExchange = Timer.scheduledTimer(withTimeInterval: Constants.XE_GasPriceUpdateTime, repeats: true) { timer in
            
            self.displayCellData()
        }
    }
    
    func displayCellData() {
        
        guard let wallet = self.walletData else { return }
        //guard let displayData = wallet.getFormattedDataDisplayModel() else { return }

        self.creditCardImage.image = UIImage(named:wallet.type.getBackgroundImage())
        self.walletTypeIcon.image = UIImage(named:wallet.type.rawValue)
                
        if wallet.type == .ethereum {
            
            self.balanaceStringLabel.text = "ETH"
            self.edgeView.isHidden = false
        } else {
            
            self.balanaceStringLabel.text = "BALANCE"
            self.edgeView.isHidden = true
        }
        
        
        self.addressLabel.text = wallet.address
        
        if let status = wallet.status {
        
            self.amountLabel.text = CryptoHelpers.generateCryptoValueString(value: status.balance ?? 0)
            self.edgeAmountLabel.text = CryptoHelpers.generateCryptoValueString(value: status.edgeBalance ?? 0)
            
            var erate: Double = 0
            if wallet.type == .ethereum {
            
                erate = Double(EtherExchangeRatesManager.shared.getRateValue())
            } else {
                
                if let rate = XEExchangeRatesManager.shared.getRates() {
                    
                    erate = rate.rate
                } else {
                    
                    erate = 0
                }
                
            }
            
            self.valueLabel.text = "\(String(format: "%.2f", Double(status.balance*erate))) USD"

        } else {
            
            self.amountLabel.text = ""
            self.valueLabel.text = ""
        }
    }
    
    public func getCardViewImage() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: self.cardView.bounds.size)
        let image = renderer.image { ctx in
            
            self.cardView.drawHierarchy(in: self.cardView.bounds, afterScreenUpdates: true)
        }
        return image
    }
}

