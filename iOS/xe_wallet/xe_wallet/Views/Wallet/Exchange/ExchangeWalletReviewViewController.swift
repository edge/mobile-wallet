//
//  ExchangeWalletReviewViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 17/02/2022.
//

import UIKit
import PanModal

enum ExchangeConfirmStatus {
    
    case confirm
    case pinEntry
    case processing
    case error
    case done
}

enum ExchangeConfirmViewEntryStatus {
    
    case none
    case pin
    
    var height: PanModalHeight {
        switch self {
            case .none: return .contentHeight(520)
            case .pin: return .contentHeight(470)
        }
    }
}

class ExchangeWalletReviewViewController: BaseViewController {

    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var pinEntryMainView: UIView!
    
    @NibWrapped(PinEntryView.self)
    @IBOutlet var pinEntryView: UIView!
    @IBOutlet weak var textEntryTextView: UITextField!
    
    @IBOutlet weak var etherValueLabel: UILabel!
    
    @IBOutlet weak var fromTokenImage: UIImageView!
    @IBOutlet weak var fromTokenAbv: UILabel!
    @IBOutlet weak var fromTokenAmount: UILabel!
    
    @IBOutlet weak var toTokenImage: UIImageView!
    @IBOutlet weak var toTokenAbv: UILabel!
    @IBOutlet weak var toTokenAmount: UILabel!
    
    @IBOutlet weak var secondTimerLabel: UILabel!
    
    @IBOutlet weak var transactionFeeLabel: UILabel!
    @IBOutlet weak var swappingAmountLabel: UILabel!
    @IBOutlet weak var receiveAmountLabel: UILabel!
    
    @IBOutlet weak var completeButtonView: UIView!
    @IBOutlet weak var completeButtonButton: UIButton!
    @IBOutlet weak var completeButtonText: UILabel!
    
    @IBOutlet weak var etherWarningMessageView: UIView!
    @IBOutlet weak var etherWarningMessageHeightConstraint: NSLayoutConstraint!
    
    var timer:Timer?
    var timerCount = 15
    var countdownStartAmount = 15
    
    var fromAddress:WalletDataModel? = nil
    var fromType:WalletType = .ethereum
    var fromAmount: Double = 0.0
    var toAddress:WalletDataModel? = nil
    var totype:WalletType = .ethereum

    var entryStatus: ExchangeConfirmViewEntryStatus = . none
    var confirmStatus = ExchangeConfirmStatus.confirm
    
    var entered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.configureViews()
        self.configureConfirmStatus()
        
        self.timerCount = self.countdownStartAmount
        var timeString = String(format: "%.2f", Double(self.timerCount)/100)
        timeString = timeString.replacingOccurrences(of: ".", with: ":")
        self.secondTimerLabel.text = timeString
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.checkForActiveReviewButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.timer != nil {
            
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    func configureViews() {
        
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
        textEntryTextView.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        /*let rate = self.getExchangeRateString()
        self.etherValueLabel.text = "1 \(self.fromType.getDataString(dataType: .coinSymbolLabel)) = 1 \(self.totype.getDataString(dataType: .coinSymbolLabel))"*/
        
        self.etherValueLabel.text = self.getExchangeRateString()
        
        var rate = 1.0
        if self.totype == .usdc {
            
            rate = Double(XEExchangeRatesManager.shared.getRateValue())
        }
        
        if self.fromType == .edge {
        
            self.etherWarningMessageView.isHidden = false
            self.etherWarningMessageHeightConstraint.constant = 50
        } else {
            
            self.etherWarningMessageView.isHidden = true
            self.etherWarningMessageHeightConstraint.constant = 0
        }
        
        
        self.fromTokenAmount.text = CryptoHelpers.generateCryptoValueString(value: self.fromAmount)
        
        self.fromTokenImage.image = UIImage(named:self.fromType.rawValue)
        self.fromTokenAbv.text = self.fromType.getDataString(dataType: .displayLabel)
        self.toTokenImage.image = UIImage(named:self.totype.rawValue)
        self.toTokenAbv.text = self.totype.getDataString(dataType: .displayLabel)
        self.toTokenAmount.text = CryptoHelpers.generateCryptoValueString(value: self.fromAmount * rate)
        
        if self.totype == .usdc {
            
            if let rates = XEExchangeRatesManager.shared.getRates() {
                
                if let gas = XEGasRatesManager.shared.getRates() {
                    
                    let fee: Double = Double(rates.gas)
                    var handling: Double = ((self.fromAmount)/100) * gas.handlingFeePercentage
                    if handling < 25 {
                        
                        handling = 25
                    }
                    let totalFee = fee + handling
                    
                    self.transactionFeeLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: totalFee)) \(self.fromType.getDataString(dataType: .coinSymbolLabel))"
                    self.swappingAmountLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: self.fromAmount)) \(self.fromType.getDataString(dataType: .coinSymbolLabel))"
                    self.receiveAmountLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: (self.fromAmount - totalFee) * rates.rate)) \(self.totype.getDataString(dataType: .coinSymbolLabel))"
                }
            }
        } else {
            
            if let gas = XEGasRatesManager.shared.getRates() {
                
                var fee: Double = 0
                if self.fromType == .xe {
                 
                    fee = Double(gas.fee)
                }
                
                var handling: Double = ((self.fromAmount)/100) * gas.handlingFeePercentage
                if handling < gas.minimumHandlingFee {
                    
                    handling = gas.minimumHandlingFee
                }
                let totalFee = fee + handling
                
                self.transactionFeeLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: totalFee)) \(self.fromType.getDataString(dataType: .coinSymbolLabel))"
                self.swappingAmountLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: self.fromAmount)) \(self.fromType.getDataString(dataType: .coinSymbolLabel))"
                self.receiveAmountLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: self.fromAmount - totalFee)) \(self.totype.getDataString(dataType: .coinSymbolLabel))"
            }
        }
    
        _pinEntryView.unwrapped.setBoxesUsed(amt: 0)
        self.textEntryTextView.text = ""
        
        self.checkForActiveReviewButton()
    }
    
    func configureConfirmStatus() {
        
        switch self.confirmStatus {
            
        case .confirm:
            self.pinEntryMainView.isHidden = true
            self.mainView.isHidden = false
            self.completeButtonView.isHidden = false
            self.completeButtonText.text = "Confirm"
            self.completeButtonView.backgroundColor = UIColor(named:"XEGreen")
            break
        case .pinEntry:
            self.pinEntryMainView.isHidden = false
            self.mainView.isHidden = true
            self.completeButtonView.isHidden = true
            self.entryStatus = .pin
            panModalSetNeedsLayoutUpdate()
            panModalTransition(to: .shortForm)
            break
        case .processing:
            self.pinEntryMainView.isHidden = true
            self.mainView.isHidden = false
            self.completeButtonView.isHidden = false
            self.completeButtonText.text = "Submitting..."
            self.completeButtonView.backgroundColor = UIColor(named:"ButtonTextInactive")
            self.entryStatus = .none
            panModalSetNeedsLayoutUpdate()
            panModalTransition(to: .shortForm)
            break
        case .error:
            //self.confirmButtonErrorLabel.text = "Failed to send coins"
            self.completeButtonText.text = "Retry"
            self.completeButtonView.backgroundColor = UIColor(named:"XEGreen")
            break
        case .done:
            break
        }
    }
    
    @IBAction func reviewContinueButtonPressed(_ sender: Any) {
        
        switch self.confirmStatus {
            
        case .confirm:

            BiometricsManager().authenticateUser(completion: { [weak self] (response) in
                switch response {
                
                case .failure:

                    self?.handleFailedBiometrics()
                case .success:

                    self?.handleExchangeAuthenticated()
                }
            })
            break
        case .pinEntry:
            break
        case .processing:
            break
        case .error:
            textEntryTextView.becomeFirstResponder()
            self._pinEntryView.unwrapped.setBoxesUsed(amt: 0)
            self.confirmStatus = .pinEntry
            self.configureConfirmStatus()
            break
        case .done:
            break
        }
    }
    
    func getExchangeRateString() -> String {
        
        if self.totype == .usdc {
            
            let exchangeValue = XEExchangeRatesManager.shared.getRateValue()
            return "1 \(self.fromType.getDataString(dataType: .coinSymbolLabel)) = \(exchangeValue) \(self.totype.getDataString(dataType: .coinSymbolLabel))"
        }
            
        return "1 \(self.fromType.getDataString(dataType: .coinSymbolLabel)) = 1 \(self.totype.getDataString(dataType: .coinSymbolLabel))"
    }
    
    func checkForActiveReviewButton() {
        
        var active = true
        
        if self.totype == .usdc {
            
            if !XEExchangeRatesManager.shared.hasUpdateInLastMinute(interval: 60) {
                
                active = false
            }
        } else {
            
            if !XEGasRatesManager.shared.hasUpdateInLastMinute(interval: 60) {
                
                active = false
            }
        }
        
        if active == false {
            
            self.completeButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.completeButtonText.textColor = UIColor(named:"FontSecondary")
            self.completeButtonButton.isEnabled = false
        } else {
            
            self.completeButtonView.backgroundColor = UIColor(named:"XEGreen")
            self.completeButtonText.textColor = UIColor(named:"FontMain")
            self.completeButtonButton.isEnabled = true
        }
    }
    
    @objc func fireTimer() {


        if self.confirmStatus != .processing {
            
            self.checkForActiveReviewButton()
            
            self.timerCount-=1
            
            if self.timerCount == 0 {
                
                self.timerCount = self.countdownStartAmount
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
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleFailedBiometrics() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            
            self.textEntryTextView.becomeFirstResponder()
            self._pinEntryView.unwrapped.setBoxesUsed(amt: 0)
            self.confirmStatus = .pinEntry
            self.configureConfirmStatus()
            
            self.entryStatus = .pin
            self.panModalSetNeedsLayoutUpdate()
            self.panModalTransition(to: .shortForm)
        }
    }
    
    func handleExchangeAuthenticated() {
        
        self.textEntryTextView.endEditing(true)
        self.confirmStatus = .processing
        self.configureConfirmStatus()
        
        let amountValue = self.fromTokenAmount.text ?? "0.0"
  
        if let wallet = self.fromAddress {
            
            let key = WalletDataModelManager.shared.loadWalletKey(key:wallet.address)
            
            if let toWallet = self.toAddress {
                
                wallet.type.exchangeCoins(wallet: wallet, toAddress: toWallet.address , toType: self.totype, amount: amountValue, fee: 0, key: key, completion: { res in
                    
                    if res {
                        
                        WalletDataModelManager.shared.exchangeRefreshNeeded = true
                        WalletDataModelManager.shared.reloadAllWalletInformationAfterDelay()
                        
                        let contentVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "ExchangeWalletCompleteViewController") as! ExchangeWalletCompleteViewController
                        contentVC.modalPresentationStyle = .overFullScreen
                        self.present(contentVC, animated: true, completion: nil)
                    } else {
                        
                        self.confirmStatus = .confirm
                        self.configureConfirmStatus()
                    }
                })
            }
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {

        if let characters = textField.text?.count {
        
            _pinEntryView.unwrapped.setBoxesUsed(amt: characters)
            if characters >= AppDataModelManager.shared.appPinCharacterLength && self.entered == false {
                
                self.entered = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    if let code = textField.text {
                    
                        if AppDataModelManager.shared.getAppPinCode() == String(code.prefix(6)) {
                            
                            self.handleExchangeAuthenticated()
                        } else {
                                                        
                            let alert = UIAlertController(title: Constants.confirmIncorrectPinMessageHeader, message: Constants.enterIncorrectPinMessageBody, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: Constants.confirmIncorrectPinButtonText, style: .default, handler: { action in

                                self._pinEntryView.unwrapped.setBoxesUsed(amt: 0)
                                self.textEntryTextView.text = ""
                                self.entered = false
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
}

extension ExchangeWalletReviewViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    //var longFormHeight: PanModalHeight { return .contentHeight(518)  }
    
    var shortFormHeight: PanModalHeight {
        
        return self.entryStatus.height
    }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
