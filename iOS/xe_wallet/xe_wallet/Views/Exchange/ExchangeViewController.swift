//
//  ExchangeViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 14/10/2021.
//

import UIKit
import XCTest

class ExchangeViewController: BaseViewController, KillViewDelegate {

        
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var creditCardImage: UIImageView!
    
    @IBOutlet weak var fromImage: UIImageView!
    @IBOutlet weak var toImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var comentLabel: UILabel!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    let cardViewTopConstraintStart: CGFloat = 66
    let cardViewTopConstraintEnd: CGFloat = 20
    let cardViewSideConstraintStart: CGFloat = 16
    let cardViewSideConstraintEnd: CGFloat = 95
    
    let cardScaleSpeed = 0.1
    
    var selectedWalletAddress = ""
    var walletData: WalletDataModel? = nil
    var cardImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.backgroundView.alpha = 0.0
        
        self.creditCardImage.image = self.cardImage
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        self.configureDisplay()
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
    
    func configureDisplay() {
        
        if walletData?.type != .xe {
            
            self.arrowImage.image = UIImage(named:"arrowRight")
            self.titleLabel.text = "Deposit XE"
            self.comentLabel.text = "Convert EDGE to XE for staking, governance and service use"
            self.fromImage.image = UIImage(named:"coin_ethereum")
            self.toImage.image = UIImage(named:"coin_xe")
            self.buttonLabel.text = "Deposit"
        } else {
            
            self.arrowImage.image = UIImage(named:"arrowRight")
            self.titleLabel.text = "Withdraw XE"
            self.comentLabel.text = "Convert XE to EDGE, governance and service use"
            self.fromImage.image = UIImage(named:"coin_xe")
            self.toImage.image = UIImage(named:"coin_ethereum")
            self.buttonLabel.text = "Withdraw"
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeButtonPressed(UIButton())
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowExchangeDepositViewController" {
            
            let controller = segue.destination as! ExchangeDepositViewController
            controller.modalPresentationStyle = .overCurrentContext
            
            controller.walletData = self.walletData
            controller.cardImage = self.cardImage
            controller.delete = self
        }
        if segue.identifier == "ShowExchangeWithdrawViewController" {
            
            let controller = segue.destination as! ExchangeWithdrawViewController
            controller.modalPresentationStyle = .overCurrentContext
            
            controller.walletData = self.walletData
            controller.cardImage = self.cardImage
            controller.delete = self
        }
    }
        
    @IBAction func closeButtonPressed(_ sender: Any) {
        
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
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        if self.walletData?.type == .xe {
            
            performSegue(withIdentifier: "ShowExchangeDepositViewController", sender: nil)
        } else {
            
            performSegue(withIdentifier: "ShowExchangeWithdrawViewController", sender: nil)
        }
            
    }
 
    func viewNeedsToHide() {
    
        self.backgroundView.alpha = 0.0
    }
    
    func killView() {
        
        self.dismiss(animated: false, completion: nil)
    }
}
