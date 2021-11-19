//
//  SendConfirmViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/11/2021.
//

import UIKit

class SendConfirmViewController: BaseViewController, UITextViewDelegate, CustomTitleBarDelegate {
        
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textEntryTextView: UITextField!
    
    @NibWrapped(PinEntryView.self)
    @IBOutlet var pinEntryView: UIView!
    
    @IBOutlet weak var customTitleBarView: CustomTitleBar!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var receiveAmountLabel: UILabel!
    
    var walletData: WalletDataModel? = nil
    var delegate: KillViewDelegate?
    var toAddress = ""
    var memo = ""
    var amount = ""
    
    var entered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.isOpaque = false
        view.backgroundColor = .clear
        self.backgroundView.alpha = 0.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        self.customTitleBarView.delegate = self
        

        self.toLabel.text = self.toAddress
        self.amountLabel.text = self.amount
        if let wallet = self.walletData {
        
            self.typeLabel.text = "(\(wallet.type.getDisplayLabel()))"
            self.receiveAmountLabel.text = "\(self.amount) \(wallet.type.getDisplayLabel())"
        }
        
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
        textEntryTextView.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        textEntryTextView.becomeFirstResponder()
        
        _pinEntryView.unwrapped.setBoxesUsed(amt: 0)
        self.textEntryTextView.text = ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.textEntryTextView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: Constants.screenFadeTransitionSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

        })
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

    
    @IBAction func backButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func dismissKeyboard() {

        view.endEditing(true)
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
                                                            
                                let amountValue = Float(self.amount)
                                let fAmount = String(format: "%.6f", amountValue!)
                                
                                WalletDataModelManager.shared.sendCoins(wallet: wallet, toAddress: self.toAddress, memo: self.memo, amount: fAmount)
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

extension SendConfirmViewController {
    
    func letButtonPressed() {
        
        self.closeWindow(callKillDelegate: false)
    }
    
    func rightButtonPressed() {

        self.closeWindow(callKillDelegate: true)
    }
}
