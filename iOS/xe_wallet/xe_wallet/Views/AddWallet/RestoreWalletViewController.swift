//
//  InitialRestoreViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/10/2021.
//

import UIKit

class RestoreWalletViewController: BaseViewController, UITextViewDelegate {
        
    @IBOutlet weak var privateKeyTextView: UITextView!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonText: UILabel!
    
    var buttonPos: CGFloat = 0
    var continueActive = false
    var type:WalletType = .xe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = false
        
        self.title = "Restore Wallet"
        
        self.privateKeyTextView.keyboardAppearance = .dark
        self.privateKeyTextView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.buttonPos = self.buttonView.frame.origin.y
        self.changeContinueButtonStatus()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.privateKeyTextView.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.buttonView.frame.origin.y = self.buttonPos - (keyboardSize.height)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        
        self.buttonView.frame.origin.y = self.buttonPos
    }
    
    @IBAction func pasteButtonPressed(_ sender: Any) {
        
        weak var pb: UIPasteboard? = .general
        guard let text = pb?.string else { return }
        self.privateKeyTextView.text = text
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        if self.continueActive {
            
            if let walletData = WalletDataModelManager.shared.restoreWallet(type: self.type, key: self.privateKeyTextView.text) {
                
                WalletDataModelManager.shared.saveWalletToSystem(wallet: walletData, type: self.type)
                
                self.performSegue(withIdentifier: "unwindToWalletView", sender: self)
            } else {
                
                
            }
        }
    }
    
    func changeContinueButtonStatus() {
        
        if self.continueActive {
            
            self.buttonText.textColor = UIColor(named: "FontMain")
            self.buttonView.backgroundColor = UIColor(named:"ButtonGreen")
        } else {
            
            self.buttonText.textColor = UIColor(named: "ButtonTextInactive")
            self.buttonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        
        if let text = textView.text {
            
            if text.count < 64 && self.continueActive || text.count >= 64 && !self.continueActive {
                
                self.continueActive.toggle()
                self.changeContinueButtonStatus()
            }
        }
    }
}
