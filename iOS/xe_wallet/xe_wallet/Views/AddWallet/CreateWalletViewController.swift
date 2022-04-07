//
//  InitialCreateViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/10/2021.
//

import UIKit
import Toast
import CryptoKit

class CreateWalletViewController: BaseViewController, CustomTitleBarDelegate {
        
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var customTitleBarView: CustomTitleBar!
    
    @IBOutlet weak var warningMessageLabel: UILabel!
    
    @IBOutlet weak var confirmOuterView: UIView!
    @IBOutlet weak var confirmInnerView: UIView!
    
    @IBOutlet weak var continueButtonView: UIView!
    @IBOutlet weak var continueButtonText: UILabel!
    
    @IBOutlet weak var walletAddressLabel: UILabel!
    @IBOutlet weak var privateKeyLabel: UILabel!
    
    @IBOutlet weak var tickImage: UIImageView!
    
    var confirmStatus = false
    var walletData: AddressKeyPairModel? = nil
    var type:WalletType = .xe
    var unwindToExchange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.backgroundView.alpha = 0.0
        
        self.walletAddressLabel.text = ""
        self.privateKeyLabel.text = ""
        
        navigationItem.hidesBackButton = false

        self.title = "Create Wallet"
        
        switch self.type {
            
        case .xe:
            break
        case .ethereum:
            break
        case .edge:
            break
        case .usdc:
            break
        }
        
        self.setConfirmStatus()
        self.initialiseWarningMessage()
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

            self.showSpinner(onView: self.backgroundView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
            
                self.walletData = self.type.createWallet()// WalletDataModelManager.shared.generateWallet(type: self.type)
                self.removeSpinner()
                if let data = self.walletData {
                    
                    self.walletAddressLabel.text = data.address
                    self.privateKeyLabel.text = data.privateKey//PD.hex()
                }
            }
        })
    }
    
    func initialiseWarningMessage() {

        let attributsBold = [NSAttributedString.Key.font : UIFont(name:"Inter-Bold", size:16)]
        let attributsNormal = [NSAttributedString.Key.font : UIFont(name:"Inter-Regular", size:16)]
        let attributedString = NSMutableAttributedString(string: "Warning. ", attributes:attributsBold)
        let boldStringPart = NSMutableAttributedString(string: "Please ensure you have backed up your private key message", attributes:attributsNormal)
        attributedString.append(boldStringPart)
      
        self.warningMessageLabel.attributedText = attributedString
    }
    
    func setConfirmStatus() {
        
        if self.confirmStatus {
            
            self.confirmInnerView.backgroundColor = UIColor(named:"ButtonGreen")
            self.confirmOuterView.backgroundColor = UIColor(named:"ButtonGreen")
            
            self.continueButtonText.textColor = UIColor(named: "FontMain")
            self.continueButtonView.backgroundColor = UIColor(named:"ButtonGreen")
            self.tickImage.isHidden = false
        } else {
            
            self.confirmInnerView.backgroundColor = UIColor(named:"BackgroundMain")
            self.confirmOuterView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            
            self.continueButtonText.textColor = UIColor(named: "ButtonTextInactive")
            self.continueButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.tickImage.isHidden = true
        }
    }
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            UIPasteboard.general.string = self.walletAddressLabel.text
            self.view.makeToast("Address copied to clipboard", duration: Constants.toastDisplayTime, position: .top)
        } else if sender.tag == 1 {
            
            UIPasteboard.general.string = self.privateKeyLabel.text
            self.view.makeToast("Private Key copied to clipboard", duration: Constants.toastDisplayTime, position: .top)
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        self.confirmStatus.toggle()
        self.setConfirmStatus()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        if self.confirmStatus {
            
            if let data = self.walletData {
            
                WalletDataModelManager.shared.saveWalletToSystem(wallet: data, type: self.type)
                
                if self.unwindToExchange == false {
                
                    NotificationCenter.default.post(name: .forceMainPageRefresh, object: nil)
                    self.performSegue(withIdentifier: "unwindToWalletView", sender: self)
                } else {
                    
                    NotificationCenter.default.post(name: .forceRefreshOnChange, object: nil)
                    self.performSegue(withIdentifier: "unwindToExchangeView", sender: self)
                }
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

extension CreateWalletViewController {
    
    func letButtonPressed() {
    }
    
    func rightButtonPressed() {
        
        self.closeWindow()
    }

}
