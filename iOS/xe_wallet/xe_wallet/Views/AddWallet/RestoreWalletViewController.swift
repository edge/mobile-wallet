//
//  InitialRestoreViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/10/2021.
//

import UIKit

class RestoreWalletViewController: BaseViewController, UITextViewDelegate, CustomTitleBarDelegate {
        
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var customTitleBarView: CustomTitleBar!
    @IBOutlet weak var privateKeyTextView: UITextView!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonText: UILabel!
    
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    var buttonBottomConstraintOriginal: CGFloat = 0
    
    var continueActive = false
    var type:WalletType = .xe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = false
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.backgroundView.alpha = 0.0
        
        self.title = "Restore Wallet"
        
        self.buttonBottomConstraintOriginal = self.buttonBottomConstraint.constant
        
        self.privateKeyTextView.keyboardAppearance = .dark
        self.privateKeyTextView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        

        self.changeContinueButtonStatus()
        
        self.customTitleBarView.delegate = self
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


        UIView.animate(withDuration: Constants.screenFadeTransitionSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { finished in
            
            self.privateKeyTextView.becomeFirstResponder()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    }
    
    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                
                self.buttonBottomConstraint.constant = self.buttonBottomConstraintOriginal + (keyboardSize.height)
                self.view.layoutIfNeeded()
            }, completion: { finished in
            })
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        

        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            
            self.buttonBottomConstraint.constant = self.buttonBottomConstraintOriginal
            self.view.layoutIfNeeded()
        }, completion: { finished in
        })
    }
    
    @IBAction func pasteButtonPressed(_ sender: Any) {
        
        weak var pb: UIPasteboard? = .general
        guard let text = pb?.string else { return }
        self.privateKeyTextView.text = text
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        if self.continueActive {
            
            self.showSpinner(onView: self.backgroundView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
            
                if let walletData = self.type.restoreWallet(key: self.privateKeyTextView.text) {
                    
                    WalletDataModelManager.shared.saveWalletToSystem(wallet: walletData, type: self.type)
                    self.removeSpinner()
                    self.performSegue(withIdentifier: "unwindToWalletView", sender: self)
                } else {
                    
                    self.removeSpinner()
                }
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
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeWindow()
        }
    }
    
    func closeWindow() {
        
        UIView.animate(withDuration: Constants.screenFadeTransitionSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

            self.dismiss(animated: false, completion: nil)
        })
    }
}

extension RestoreWalletViewController {
    
    func letButtonPressed() {
    }
    
    func rightButtonPressed() {
        
        self.closeWindow()
    }
}
