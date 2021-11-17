//
//  DepositViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 06/11/2021.
//

import UIKit

class ExchangeDepositViewController: BaseViewController, KillViewDelegate, CustomTitleBarDelegate {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var creditCardImage: UIImageView!

    @IBOutlet weak var customTitleBarView: CustomTitleBar!
    
    let cardViewTopConstraintStart: CGFloat = 66
    let cardViewTopConstraintEnd: CGFloat = 20
    let cardViewSideConstraintStart: CGFloat = 16
    let cardViewSideConstraintEnd: CGFloat = 95
    
    let cardScaleSpeed = 0.6
    
    var walletData: WalletDataModel? = nil
    var cardImage: UIImage? = nil
    
    var delegate: KillViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.creditCardImage.image = self.cardImage
        self.backgroundView.alpha = 0.0
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        self.customTitleBarView.delegate = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowExchangeDepositConfirmViewController" {
            
            let controller = segue.destination as! ExchangeDepositConfirmViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.delegate = self
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeWindow()
        }
    }
    
    @IBAction func depositButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ShowExchangeDepositConfirmViewController", sender: nil)
    }
    
    func closeWindow() {
        
        self.cardViewTopConstraint.constant = self.cardViewTopConstraintStart
        self.cardViewRightConstraint.constant = self.cardViewSideConstraintStart
        self.cardViewLeftConstraint.constant = self.cardViewSideConstraintStart
        UIView.animate(withDuration: self.cardScaleSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

            self.dismiss(animated: false, completion: nil)
            self.delegate?.killView()
        })
    }
    
    func viewNeedsToShow() {
    
        self.backgroundView.alpha = 1.0
    }
    
    func killView() {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func viewNeedsToHide() {
        
        self.view.alpha = 0.0
    }
}

extension ExchangeDepositViewController {
    
    func letButtonPressed() {
    }
    
    func rightButtonPressed() {

        self.closeWindow()
    }
}
