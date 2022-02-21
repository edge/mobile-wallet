//
//  ExchangeWalletReviewViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 17/02/2022.
//

import UIKit
import PanModal

class ExchangeWalletReviewViewController: BaseViewController {

    @IBOutlet weak var etherValueLabel: UILabel!
    
    @IBOutlet weak var fromTokenImage: UIImageView!
    @IBOutlet weak var fromTokenAbv: UILabel!
    @IBOutlet weak var fromTokenAmount: UILabel!
    
    @IBOutlet weak var toTokenImage: UIImageView!
    @IBOutlet weak var toTokenAbv: UILabel!
    @IBOutlet weak var toTokenAmount: UILabel!
    
    @IBOutlet weak var secondTimerLabel: UILabel!
    
    @IBOutlet weak var estimatedFeeLabel: UILabel!
    @IBOutlet weak var maximumFeeLabel: UILabel!
    
    @IBOutlet weak var completeButtonView: UIView!
    @IBOutlet weak var completeButtonButton: UIButton!
    @IBOutlet weak var completeButtonText: UILabel!
    
    var timer:Timer?
    var timerCount = 30
    
    var fromAddress:WalletDataModel? = nil
    var fromType:WalletType = .ethereum
    var fromAmount: Double = 0.0
    var toAddress:WalletDataModel? = nil
    var totype:WalletType = .ethereum

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.configureViews()
        
        self.timerCount = 30
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.timer != nil {
            
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    func configureViews() {
        
        let rate = self.getExchangeRateString()
        self.etherValueLabel.text = "1 \(self.fromType.getCoinSymbol()) = \(CryptoHelpers.generateCryptoValueString(value: rate)) \(self.totype.getCoinSymbol())"
        
        self.fromTokenAmount.text = CryptoHelpers.generateCryptoValueString(value: self.fromAmount)
        
        self.fromTokenImage.image = UIImage(named:self.fromType.rawValue)
        self.fromTokenAbv.text = self.fromType.getDisplayLabel()
        self.toTokenImage.image = UIImage(named:self.totype.rawValue)
        self.toTokenAbv.text = self.totype.getDisplayLabel()
        self.toTokenAmount.text = CryptoHelpers.generateCryptoValueString(value: self.fromAmount * rate)
        
        if let gas = XEGasRatesManager.shared.getRates() {
            
            self.estimatedFeeLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: ((self.fromAmount)/100) * gas.handlingFeePercentage))"
            self.maximumFeeLabel.text = ""
        }
        
        self.checkForActiveReviewButton()
    }
    
    func getExchangeRateString() -> Double {
        
        let exchangeData = XEExchangeRateCurrentManager.shared.getRates()
        
        if self.fromType == .xe || self.fromType == .edge {
            
            if self.totype == .xe || self.totype == .edge {
                
                return 1.0
            } else {
                
                if let eth = exchangeData?.ethPerXE {
                
                    return eth
                }
            }
        } else {
            
            if self.totype == .xe || self.totype == .edge {
                
                if let eth = exchangeData?.ethPerXE {
                
                    return 1/eth
                }
            }
        }

        return 1.0
    }
    
    func checkForActiveReviewButton() {
        
        var active = true
        
        if active == false {
            
            self.completeButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.completeButtonText.textColor = UIColor(named:"FontSecondary")
            self.completeButtonButton.isEnabled = false
        } else {
            
            self.completeButtonView.backgroundColor = UIColor(named:"ButtonGreen")
            self.completeButtonText.textColor = UIColor(named:"FontMain")
            self.completeButtonButton.isEnabled = true
        }
    }
    
    @objc func fireTimer() {

        self.timerCount-=1
        
        if self.timerCount == -1 {
            
            self.timerCount = 30
            self.configureViews()
        }
        
        var timeString = String(format: "%.2f", Double(self.timerCount)/100)
        timeString = timeString.replacingOccurrences(of: ".", with: ":")
        self.secondTimerLabel.text = timeString
        
        if self.timerCount <= 5 {
            
            self.secondTimerLabel.textColor = .red
        } else {
            
            self.secondTimerLabel.textColor = UIColor(named: "FontMain")
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        
        let contentVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "ExchangeWalletCompleteViewController") as! ExchangeWalletCompleteViewController
        contentVC.modalPresentationStyle = .overFullScreen
        present(contentVC, animated: false, completion: nil)
    }
}

extension ExchangeWalletReviewViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .contentHeight(520)  }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
