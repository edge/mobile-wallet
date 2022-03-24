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
    
    @IBOutlet weak var selectXEMainView: UIView!
    @IBOutlet weak var selectXEButton: UIButton!
    
    
    @IBOutlet weak var closeXIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeXIconRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var customTitleBarView: CustomTitleBar!
    var selected:WalletType = .xe
    var preventXE = true
    var unwindToExchange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        self.customTitleBarView.delegate = self
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        if self.preventXE {
            
            self.selectXEButton.isEnabled = false
            self.selectXEMainView.alpha = 0.2
            self.selected = .ethereum

        } else {
            
            self.selectXEButton.isEnabled = true
            self.selectXEMainView.alpha = 1.0
            self.selected = .xe
        }
        self.configureSelectedButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            controller.unwindToExchange = self.unwindToExchange
        }
        
        if segue.identifier == "RestoreWalletViewController" {
            
            let controller = segue.destination as! RestoreWalletViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.type = self.selected
            controller.unwindToExchange = self.unwindToExchange
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
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddWalletViewController {
    
    func letButtonPressed() {
    }
    
    func rightButtonPressed() {
        
        self.closeWindow()
    }

}
