//
//  InitialCreateViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/10/2021.
//

import UIKit

class CreateWalletViewController: BaseViewController {
        
    @IBOutlet weak var warningMessageLabel: UILabel!
    
    @IBOutlet weak var confirmOuterView: UIView!
    @IBOutlet weak var confirmInnerView: UIView!
    
    @IBOutlet weak var continueButtonView: UIView!
    @IBOutlet weak var continueButtonText: UILabel!
    
    @IBOutlet weak var walletAddressLabel: UILabel!
    @IBOutlet weak var privateKeyLabel: UILabel!
    
    var confirmStatus = false
    var walletData: AddressKeyPairModel? = nil
    var type:WalletType = .xe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = false

        self.title = "Create Wallet"
        
        switch self.type {
            
        case .xe:
            break
        case .ethereum:
            break
        case .edge:
            break
        }
        
        
        self.walletData = WalletDataModelManager.shared.generateWallet(type: self.type)
        
        if let data = self.walletData {
        
            self.walletAddressLabel.text = data.address
            self.privateKeyLabel.text = data.privateKey//PD.hex()
        }
        self.initialiseWarningMessage()
        self.setConfirmStatus()
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
        } else {
            
            self.confirmInnerView.backgroundColor = UIColor(named:"BackgroundMain")
            self.confirmOuterView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            
            self.continueButtonText.textColor = UIColor(named: "ButtonTextInactive")
            self.continueButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
        }
    }
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            UIPasteboard.general.string = self.walletAddressLabel.text
        } else if sender.tag == 1 {
            
            UIPasteboard.general.string = self.privateKeyLabel.text
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
                
                self.performSegue(withIdentifier: "unwindToWalletView", sender: self)
            }
        }
    }
}
