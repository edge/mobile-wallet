//
//  DepositViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 06/11/2021.
//

import UIKit

class ExchangeDepositViewController: BaseViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var creditCardImage: UIImageView!
    
    let cardViewTopConstraintStart: CGFloat = 66
    let cardViewTopConstraintEnd: CGFloat = 20
    let cardViewSideConstraintStart: CGFloat = 16
    let cardViewSideConstraintEnd: CGFloat = 95
    
    let cardScaleSpeed = 0.1
    
    var walletData: WalletDataModel? = nil
    var cardImage: UIImage? = nil
    
    var delete: KillViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.creditCardImage.image = self.cardImage
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeButtonPressed(UIButton())
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        
        self.delete?.viewNeedsToHide()
        self.cardViewTopConstraint.constant = self.cardViewTopConstraintStart
        self.cardViewRightConstraint.constant = self.cardViewSideConstraintStart
        self.cardViewLeftConstraint.constant = self.cardViewSideConstraintStart
        UIView.animate(withDuration: self.cardScaleSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

            self.dismiss(animated: false, completion: nil)
            self.delete?.killView()
        })
    }
}
