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
    
    @IBOutlet weak var backupView: UIView!
    
    var timerExchange: Timer?
    
    var walletData: WalletDataModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.iconCircleView.layer.cornerRadius = self.iconCircleView.frame.height / 2
        //self.iconCircleView.layer.borderWidth = 2
        //self.iconCircleView.layer.borderColor = UIColor.darkGray.cgColor
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
        self.creditCardImage.image = UIImage(named:data.type.getBackgroundImage())
        self.walletTypeIcon.image = UIImage(named:data.type.rawValue)
        self.addressLabel.text = data.address
        
        var amount = 0
        if let status = data.status {
            
            amount = status.balance
        }
        self.displayValue()
        let valString = CryptoHelpers.generateCryptoValueString(value: (Double(amount)/1000000) ?? 0)
        self.amountLabel.text = "\(valString) \(data.type.getDisplayLabel())"
        
        self.timerExchange = Timer.scheduledTimer(withTimeInterval: Constants.XE_GasPriceUpdateTime, repeats: true) { timer in
            
            self.displayValue()
        }
    }
    
    func displayValue() {
        
        if let dat = self.walletData {
            
            var totalValue: Double = 0
            var amount = 0
            if let status = dat.status {
                
                amount = status.balance
            }
            let value = Double(amount)/1000000
            
            if dat.type == .ethereum {
                
                let exchangeRate = ExchangeRatesManager.shared.getEtherRate().doubleValue
                totalValue = Double(value) * Double(exchangeRate)
            } else if dat.type == .xe {
                
                let exchangeRates = ExchangeRatesManager.shared.getRates()
                totalValue = value * Double(exchangeRates?.rate ?? 0)
            }
            let val = "$\(String(format: "%.2f", totalValue)) USD"
            self.valueLabel.text = val
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

