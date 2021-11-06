//
//  ExchangeViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 14/10/2021.
//

import UIKit

class ExchangeViewController: BaseViewController {
        
    @IBOutlet var backgroundView: UIView!
    
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
    
    var selectedWalletAddress = ""
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
}
