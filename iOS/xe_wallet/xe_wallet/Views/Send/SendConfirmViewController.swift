//
//  SendConfirmViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/11/2021.
//

import UIKit
import PanModal

enum SendConfirmStatus {
    
    case confirm
    case pinEntry
    case processing
    case error
    case done
}

enum SendConfirmViewEntryStatus {
    
    case none
    case pin
    
    var height: PanModalHeight {
        switch self {
            case .none: return .contentHeight(554)
            case .pin: return .contentHeight(784)
        }
    }
}

protocol SendConfirmViewControllerDelegate {

    func killView()
}

class SendConfirmViewController: BaseViewController, UITextViewDelegate {
        
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textEntryTextView: UITextField!
    
    @NibWrapped(PinEntryView.self)
    @IBOutlet var pinEntryView: UIView!
        
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var receiveAmountLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    
    @IBOutlet weak var pinEntryMainView: UIView!
    @IBOutlet weak var confirmButtonText: UILabel!
    @IBOutlet weak var confirmButtonMainView: UIView!
    @IBOutlet weak var confirmButtonOutterView: UIView!
    @IBOutlet weak var confirmButtonErrorLabel: UILabel!
    
    var delegate: SendConfirmViewControllerDelegate?
    var entryStatus: SendConfirmViewEntryStatus = . none
    
    var walletData: WalletDataModel? = nil
    var toAddress = ""
    var fromAddress = ""
    var memo = ""
    var amount = ""
    var walletType: WalletType = .ethereum
    
    var entered = false
    var confirmStatus = SendConfirmStatus.confirm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.configureViews()

        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
        textEntryTextView.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

        
        _pinEntryView.unwrapped.setBoxesUsed(amt: 0)
        self.textEntryTextView.text = ""
        
        self.configureConfirmStatus()
    }

    
    func configureViews() {
        
        self.title = "Confirm"
        
        self.amountLabel.text = self.amount
        self.toLabel.text = self.toAddress
        self.fromLabel.text = self.fromAddress
        
        
        
        let valString = CryptoHelpers.generateCryptoValueString(value: Double(self.amount) ?? 0)
                
        self.amountLabel.text = valString
        self.receiveAmountLabel.text = "\(valString) \(self.walletType.getCoinSymbol())"
        self.typeLabel.text = "(\(self.walletType.getDisplayLabel()))"
        self.feeLabel.text = "Fee: 0 \(self.walletType.getCoinSymbol()) ($0.00)"
        /*
        if let wallet = self.walletData {
        
            self.typeLabel.text = "(\(wallet.type.getDisplayLabel()))"
            
            var valTypeLabel = "XE"
            if wallet.type != .xe {
                
                var edgeAmount = "0.0"
                if let status = wallet.status {
                    
                    edgeAmount = CryptoHelpers.generateCryptoValueString(value: status.edgeBalance ?? 0)
                }
                
                
                if memo.lowercased() == "edge" {
                    
                    valTypeLabel = "EDGE"
                } else {
                    
                    valTypeLabel = "ETH"
                }
            }
            
            self.receiveAmountLabel.text = "\(valString) \(valTypeLabel)"
        }*/
    }
    
    func configureConfirmStatus() {
        
        switch self.confirmStatus {
            
        case .confirm:
            self.pinEntryMainView.isHidden = true
            self.confirmButtonOutterView.isHidden = false
            self.confirmButtonText.text = "Confirm"
            self.confirmButtonMainView.backgroundColor = UIColor(named:"ButtonGreen")
            break
        case .pinEntry:
            self.pinEntryMainView.isHidden = false
            self.confirmButtonOutterView.isHidden = true
            break
        case .processing:
            self.pinEntryMainView.isHidden = true
            self.confirmButtonOutterView.isHidden = false
            self.confirmButtonText.text = "Submitting..."
            self.confirmButtonMainView.backgroundColor = UIColor(named:"ButtonTextInactive")
            self.entryStatus = .none
            panModalSetNeedsLayoutUpdate()
            panModalTransition(to: .shortForm)
            break
        case .error:
            self.confirmButtonErrorLabel.text = "Failed to send coins"
            self.confirmButtonText.text = "Retry"
            self.confirmButtonMainView.backgroundColor = UIColor(named:"ButtonGreen")
            break
        case .done:
            break
        }
    }
    
    @IBAction func reviewContinueButtonPressed(_ sender: Any) {
        
        switch self.confirmStatus {
            
        case .confirm:
            textEntryTextView.becomeFirstResponder()
            self._pinEntryView.unwrapped.setBoxesUsed(amt: 0)
            self.confirmStatus = .pinEntry
            self.configureConfirmStatus()
            
            self.entryStatus = .pin
            panModalSetNeedsLayoutUpdate()
            panModalTransition(to: .shortForm)
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
    
    /*@objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeWindow(callKillDelegate: true)
        }
    }*/
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {

        if let characters = textField.text?.count {
        
            _pinEntryView.unwrapped.setBoxesUsed(amt: characters)
            if characters >= AppDataModelManager.shared.appPinCharacterLength && self.entered == false {
                
                self.entered = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    if let code = textField.text {
                    
                        if AppDataModelManager.shared.getAppPinCode() == String(code.prefix(6)) {
                            
                            if let wallet = self.walletData {
                                               
                                self.textEntryTextView.endEditing(true)
                                self.confirmStatus = .processing
                                self.configureConfirmStatus()
                                
                                let amountValue = Float(self.amount)
                                let fAmount = String(format: "%.6f", amountValue!)
                                
                                let key = WalletDataModelManager.shared.loadWalletKey(key:wallet.address)
                                self.walletType.sendCoins(wallet: wallet, toAddress: self.toAddress, memo: self.memo, amount: fAmount, key: key, completion: { res in
                                    
                                    if res {
                                        
                                        self.performSegue(withIdentifier: "unwindToWalletView", sender: self)
                                        
                                    } else {
                                        
                                        self.confirmStatus = .error
                                        self.configureConfirmStatus()
                                    }
                                })
                            }
                        } else {
                                                        
                            let alert = UIAlertController(title: Constants.confirmIncorrectPinMessageHeader, message: Constants.confirmIncorrectPinMessageBody, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: Constants.confirmIncorrectPinButtonText, style: .default, handler: { action in

                                self._pinEntryView.unwrapped.setBoxesUsed(amt: 0)
                                self.textEntryTextView.text = ""
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
}


extension SendConfirmViewController: PanModalPresentable {
    
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
