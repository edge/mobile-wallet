//
//  ExchangeDepositConfirmViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 08/11/2021.
//

import UIKit

class ExchangeDepositConfirmViewController: BaseViewController, CustomTitleBarDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var customTitleBarView: CustomTitleBar!
    
    @IBOutlet weak var fromImageView: UIImageView!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var fromAmountLabel: UILabel!
    
    @IBOutlet weak var toImageView: UIImageView!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var toAmountLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @NibWrapped(PinEntryView.self)
    @IBOutlet var pinEntryView: UIView!
    @IBOutlet weak var textEntryTextView: UITextField!
    
    @IBOutlet weak var pinEntryMainView: UIView!
    @IBOutlet weak var confirmButtonText: UILabel!
    @IBOutlet weak var confirmButtonMainView: UIView!
    @IBOutlet weak var confirmButtonOutterView: UIView!
    @IBOutlet weak var confirmButtonErrorLabel: UILabel!
    
    var delegate: KillViewDelegate?
    
    var walletData: WalletDataModel? = nil
    var toWalletData: WalletDataModel? = nil
    
    var amount = ""
    var entered = false
    
    var confirmStatus = SendConfirmStatus.confirm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.backgroundView.alpha = 0.0
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        self.customTitleBarView.delegate = self
        
        if let fWallet = self.walletData {
            
            self.fromImageView.image = UIImage(named: fWallet.type.rawValue )
            self.fromAddressLabel.text = fWallet.address
            //self.fromAmountLabel.text = "\(String(format: "%.6f", Double(fWallet.status?.balance ?? 00)/1000000)) \(fWallet.type.getDisplayLabel())"
        }
        
        if let tWallet = self.toWalletData {
            
            self.toImageView.image = UIImage(named: tWallet.type.rawValue )
            self.toAddressLabel.text = tWallet.address
            //self.toAmountLabel.text = "\(String(format: "%.6f", Double(tWallet.status?.balance ?? 00)/1000000)) \(tWallet.type.getDisplayLabel())"
        }
        
        self.amountLabel.text = self.amount
        
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
        textEntryTextView.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        textEntryTextView.becomeFirstResponder()
        
        _pinEntryView.unwrapped.setBoxesUsed(amt: 0)
        self.textEntryTextView.text = ""
        
        self.configureConfirmStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: Constants.screenFadeTransitionSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

        })
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
            break
        case .error:
            self.confirmButtonErrorLabel.text = "Failed to withdraw coins"
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
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeWindow(callKillDelegate: true)
        }
    }

    func closeWindow(callKillDelegate: Bool) {
        
        if callKillDelegate {
        
            self.delegate?.viewNeedsToHide()
        } else {
        
            self.delegate?.viewNeedsToShow()
        }
        UIView.animate(withDuration: Constants.screenFadeTransitionSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

            self.dismiss(animated: false, completion: nil)
            if callKillDelegate {
            
                self.delegate?.killView()
            }
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

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
                                wallet.type.exchangeCoins(wallet: wallet, toAddress: self.toWalletData?.address ?? "", amount: fAmount, fee: 0, key: key, completion: { res in
                                    
                                    if res {
                                        
                                        self.closeWindow(callKillDelegate: true)
                                    } else {
                                        
                                        self.confirmStatus = .error
                                        self.configureConfirmStatus()
                                    }
                                })
                                
                                self.closeWindow(callKillDelegate: true)
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

extension ExchangeDepositConfirmViewController {
    
    func letButtonPressed() {
        
        self.closeWindow(callKillDelegate: false)
    }
    
    func rightButtonPressed() {

        self.closeWindow(callKillDelegate: true)
    }
}
