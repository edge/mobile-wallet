//
//  WalletMarketTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/01/2022.
//

import UIKit

class WalletMarketTableViewCell: UITableViewCell {
            
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenNameLabel: UILabel!
    @IBOutlet weak var tokenAbvLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    
    @IBOutlet weak var tokenValueLabel: UILabel!
    @IBOutlet weak var tokenPercentChangeLabel: UILabel!
    @IBOutlet weak var tokenChangeImage: UIImageView!
    @IBOutlet weak var lineChart: LineChart!
    
    var type = WalletType.ethereum
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let dataEntries = generatePointEntries()
        lineChart.dataEntries = dataEntries
        lineChart.isCurved = true
        let gap = (self.lineChart.frame.width - 0) / 6
        lineChart.lineGap = gap
    }
    
    func configure(data: String) {
        
        self.type = .edge
        
        var rate = 0.0
        if let rates = XEExchangeRateCurrentManager.shared.getRates() {
            
            rate = rates.usdPerXE
        }
        
        if data == "Ethereum" {
        
            self.type = .ethereum
            rate = Double(EtherExchangeRatesManager.shared.getRateValue())
        }

        let percent = XEExchangeRateHistoryManager.shared.getRateHistoryPercentage(type: type)
        
        self.tokenPercentChangeLabel.text = "\(String(format: "%.2f", Double(percent)))%"
        if percent < 0 {
        
            self.tokenPercentChangeLabel.textColor = UIColor.red
        } else {
            
            self.tokenPercentChangeLabel.textColor = UIColor(named: "XEGreen")
        }
        
        if data == "Ethereum" {
            
            self.tokenValueLabel.text = "$\(StringHelpers.generateValueString(value: Double(truncating: rate as! NSNumber)))"
        } else {
        
            self.tokenValueLabel.text = "$\(StringHelpers.generateValueString4Dec(value: Double(truncating: rate as! NSNumber)))"
        }
        self.tokenImage.image = UIImage(named:type.rawValue)
        self.tokenNameLabel.text = self.type.getFullNameLabel()
        self.tokenAbvLabel.text = self.type.getCoinSymbol()
        self.tokenChangeImage.image = XEExchangeRateHistoryManager.shared.getRatePerformanceImage(type: self.type)
    }
    
    private func generatePointEntries() -> [PointEntry] {
           
        var result: [PointEntry] = []
        if let rates = XEExchangeRateHistoryManager.shared.getRates(type: self.type) {
            
            for rate in rates {
                
                let val = rate * Double(10000)
                result.append(PointEntry(value: Int(val), label: ""))
            }
        }
        return result
    }
    
}
