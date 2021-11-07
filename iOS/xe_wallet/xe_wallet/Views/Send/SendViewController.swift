//
//  SendViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 14/10/2021.
//

import UIKit

class SendViewController: BaseViewController, UITextFieldDelegate, KillViewDelegate {
        
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
    
    let cardViewTopConstraintStart: CGFloat = 66
    let cardViewTopConstraintEnd: CGFloat = 20
    let cardViewSideConstraintStart: CGFloat = 16
    let cardViewSideConstraintEnd: CGFloat = 95
    
    let cardScaleSpeed = 0.1
    
    var selectedWalletAddress = ""
    var walletData: WalletDataModel? = nil
    
    var cardFrame: CGRect? = nil
    
    var cardImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.backgroundView.alpha = 0.0
        self.cardViewTopConstraint.constant = self.cardViewTopConstraintStart
        self.cardViewRightConstraint.constant = self.cardViewSideConstraintStart
        self.cardViewLeftConstraint.constant = self.cardViewSideConstraintStart
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.cardViewTopConstraint.constant = self.cardViewTopConstraintEnd
        self.cardViewRightConstraint.constant = self.cardViewSideConstraintEnd
        self.cardViewLeftConstraint.constant = self.cardViewSideConstraintEnd
        UIView.animate(withDuration: self.cardScaleSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

        })
    }
        
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeButtonPressed(UIButton())
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        
        self.cardViewTopConstraint.constant = self.cardViewTopConstraintStart
        self.cardViewRightConstraint.constant = self.cardViewSideConstraintStart
        self.cardViewLeftConstraint.constant = self.cardViewSideConstraintStart
        UIView.animate(withDuration: self.cardScaleSpeed, delay: 0, options: .curveEaseOut, animations: {

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
            controller.cardImage = self.cardImage
            controller.delete = self
        }
    }
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ShowSendReviewViewController", sender: nil)
    }
    
    func viewNeedsToHide() {
    
        self.backgroundView.alpha = 0.0
    }
    
    func killView() {
        
        self.dismiss(animated: false, completion: nil)
    }
}
