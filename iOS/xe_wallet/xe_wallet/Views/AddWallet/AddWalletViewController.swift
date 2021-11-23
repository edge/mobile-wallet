//
//  AddWalletViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 02/11/2021.
//

import UIKit

class AddWalletViewController: BaseViewController, CustomTitleBarDelegate {
        
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var xeCircleView: UIView!
    @IBOutlet weak var xeInnerCircleView: UIView!
    @IBOutlet weak var xeWalletTickImage: UIImageView!
    @IBOutlet weak var etherCircleView: UIView!
    @IBOutlet weak var etherInnerCircleView: UIView!
    @IBOutlet weak var etherWalletTickImage: UIImageView!
    
    @IBOutlet weak var closeXIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeXIconRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var customTitleBarView: CustomTitleBar!
    var selected:WalletType = .xe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.backgroundView.alpha = 0.0
        
        navigationItem.hidesBackButton = true
        self.title = "Add Wallet"
        
        self.configureSelectedButtons()

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

        })
    }
    
    func configureSelectedButtons() {
        
        if self.selected == .xe {
            
            self.xeCircleView.backgroundColor = UIColor(named:"ButtonGreen")
            self.xeInnerCircleView.backgroundColor = UIColor(named:"ButtonGreen")
            self.etherCircleView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.etherInnerCircleView.backgroundColor = UIColor(named:"MainBlack")
            self.xeWalletTickImage.isHidden = false
            self.etherWalletTickImage.isHidden = true
        } else {
            
            self.xeCircleView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.xeInnerCircleView.backgroundColor = UIColor(named:"MainBlack")
            self.etherCircleView.backgroundColor = UIColor(named:"ButtonGreen")
            self.etherInnerCircleView.backgroundColor = UIColor(named:"ButtonGreen")
            self.xeWalletTickImage.isHidden = true
            self.etherWalletTickImage.isHidden = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CreateWalletViewController" {
            
            let controller = segue.destination as! CreateWalletViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.type = self.selected
        }
        
        if segue.identifier == "RestoreWalletViewController" {
            
            let controller = segue.destination as! RestoreWalletViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.type = self.selected
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func xeButtonPressed(_ sender: Any) {
        
        self.selected = .xe
        self.configureSelectedButtons()
    }
    
    @IBAction func etherButtonPressed(_ sender: Any) {
        
        self.selected = .ethereum
        self.configureSelectedButtons()
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "CreateWalletViewController", sender: nil)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "RestoreWalletViewController", sender: nil)
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

extension AddWalletViewController {
    
    func letButtonPressed() {
    }
    
    func rightButtonPressed() {
        
        self.closeWindow()
    }

}
