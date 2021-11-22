//
//  SendViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 14/10/2021.
//

import UIKit

class SendViewController: BaseViewController, UITextFieldDelegate, KillViewDelegate, CustomTitleBarDelegate {

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var creditCardImage: UIImageView!
    
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
                
    @IBOutlet weak var customTitleBarView: CustomTitleBar!

    @IBOutlet weak var reviewButtonView: UIView!
    @IBOutlet weak var reviewButtonText: UILabel!
    
    var selectedWalletAddress = ""
    var walletData: WalletDataModel? = nil
    
    var cardFrame: CGRect? = nil
    var cardImage: UIImage? = nil
    
    var isReviewActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.backgroundView.alpha = 0.0
        self.cardViewTopConstraint.constant = Constants.cardViewTopConstraintStart
        self.cardViewRightConstraint.constant = Constants.cardViewSideConstraintStart
        self.cardViewLeftConstraint.constant = Constants.cardViewSideConstraintStart
        self.view.layoutIfNeeded()
        
        self.walletData = WalletDataModelManager.shared.getWalletDataWithAddress(address: self.selectedWalletAddress)
        
        self.creditCardImage.image = self.cardImage
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name:"Inter-Medium", size:14), NSAttributedString.Key.foregroundColor : UIColor(named:"FontSecondary")]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name:"Inter-Medium", size:14), NSAttributedString.Key.foregroundColor : UIColor(named:"FontOptional")]
        let attributedString1 = NSMutableAttributedString(string:"Memo ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"(optional)", attributes:attrs2)
        attributedString1.append(attributedString2)
        self.memoLabel.attributedText = attributedString1

        self.toTextField.attributedPlaceholder = NSAttributedString(
            string: "XE wallet address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named:"PlaceHolderFont") ?? .white])
        self.memoTextField.attributedPlaceholder = NSAttributedString(
            string: "Leave a memo",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named:"PlaceHolderFont") ?? .white])
        self.amountTextField.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named:"PlaceHolderFont") ?? .white])
        
        self.toTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.amountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)

        self.customTitleBarView.delegate = self
        
        self.configureReviewButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.cardViewTopConstraint.constant = Constants.cardViewTopConstraintEnd
        self.cardViewRightConstraint.constant = Constants.cardViewSideConstraintEnd
        self.cardViewLeftConstraint.constant = Constants.cardViewSideConstraintEnd
        UIView.animate(withDuration: Constants.screenFadeTransitionSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

        })
    }
    
    func configureReviewButton() {
        
        if self.isReviewActive {
            
            self.reviewButtonView.backgroundColor = UIColor(named:"ButtonGreen")
            self.reviewButtonText.textColor = UIColor(named: "FontMain")
        } else {
            
            self.reviewButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.reviewButtonText.textColor = UIColor(named: "ButtonTextInactive")
        }
    }
        
    @objc func textFieldDidChange(_ textField: UITextField) {

        var shouldBeActive = false
        
        guard let amountText = self.amountTextField.text else { return }
        guard let toText = self.toTextField.text else { return }
        guard let amountVal = Double(amountText) else { return }
        guard let wallet = self.walletData else { return }
        guard let status = wallet.status else { return }
        
        if amountText != "" {
            
            let walletAmount = status.balance
            
            if amountVal >= wallet.type.getMinSendValue() && amountVal <= Double(walletAmount)/1000000 {
                
                shouldBeActive = true
                
                if toText.count != wallet.type.getWalletCharacterLength() || !toText.hasPrefix(wallet.type.getWalletPrefix()) {
                    
                    shouldBeActive = false
                }
            }
        }
                
        if self.isReviewActive != shouldBeActive {
            
            self.isReviewActive = shouldBeActive
            self.configureReviewButton()
        }
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeWindow()
        }
    }
    
    func closeWindow() {
        
        self.cardViewTopConstraint.constant = Constants.cardViewTopConstraintStart
        self.cardViewRightConstraint.constant = Constants.cardViewSideConstraintStart
        self.cardViewLeftConstraint.constant = Constants.cardViewSideConstraintStart
        UIView.animate(withDuration: Constants.screenFadeTransitionSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

            self.dismiss(animated: false, completion: nil)
        })
    }
    
    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
          
            textField.resignFirstResponder()
            self.memoTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
          
            textField.resignFirstResponder()
            self.amountTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
          
            textField.resignFirstResponder()
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowSendReviewViewController" {
            
            let controller = segue.destination as! SendConfirmViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.walletData = self.walletData
            controller.delegate = self
            var toAddress = ""
            if let to = self.toTextField.text {
                
                toAddress = to
            }
            controller.toAddress = toAddress
            var amount = "0"
            if let amt = self.amountTextField.text {
                
                amount = amt
            }
            controller.amount = amount
            var memo = ""
            if let mem = self.memoTextField.text {
                
                memo = mem
            }
            controller.memo = memo
            
        }
    }
    
    @IBAction func pasteButtonPressed(_ sender: Any) {
        
        weak var pb: UIPasteboard? = .general
        guard let text = pb?.string else { return }
        self.toTextField.text = text
    }
    
    @IBAction func maxButtonPressed(_ sender: Any) {
        
        if let status = self.walletData?.status {
            
            self.amountTextField.text = "\(String(format: "%.6f", Double(status.balance)/1000000))"
        }
    }
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        
        if self.isReviewActive {
        
            performSegue(withIdentifier: "ShowSendReviewViewController", sender: nil)
        }
    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Check here decimal places
        if (textField.text?.contains("."))! {
            let limitDecimalPlace = 6
            let decimalPlace = textField.text?.components(separatedBy: ".").last
            if (decimalPlace?.count)! < limitDecimalPlace {
                return true
            }
            else {
                return false
            }
        }
        return true
    }*/
}

extension SendViewController {
    
    func viewNeedsToHide() {
    
        self.view.alpha = 0.0
    }
    
    func viewNeedsToShow() {
    
        self.view.alpha = 1.0
        self.backgroundView.alpha = 1.0
    }
    
    func killView() {
        
        self.dismiss(animated: false, completion: nil)
    }
}

extension SendViewController {
    
    func letButtonPressed() {
    }
    
    func rightButtonPressed() {

        self.closeWindow()
    }
}
