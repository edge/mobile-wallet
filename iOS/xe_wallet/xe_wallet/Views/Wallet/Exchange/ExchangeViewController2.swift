//
//  ExchangeViewController2.swift
//  xe_wallet
//
//  Created by Paul Davis on 03/01/2022.
//

import Foundation
import UIKit

class ExchangeViewController2: UIViewController, ExchangeWalletSelectionViewControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var addressTokenImage: UIImageView!
    @IBOutlet weak var addressAddressLabel: UILabel!
    
    @IBOutlet weak var swapFromCardImage: UIImageView!
    @IBOutlet weak var swapFromTokenImage: UIImageView!
    @IBOutlet weak var swapFromTokenAbv: UILabel!
    @IBOutlet weak var swapFromAmountTextField: UITextField!
    @IBOutlet weak var swapFromSelectImage: UIImageView!
    @IBOutlet weak var swapFromTokenSelectButton: UIButton!
    @IBOutlet weak var swapFromAvailableLabel: UILabel!
    
    @IBOutlet weak var swapToCardImage: UIImageView!
    @IBOutlet weak var swapToTokenImage: UIImageView!
    @IBOutlet weak var swapToAddressLabel: UILabel!
    
    @IBOutlet weak var swapToTokenTokenImage: UIImageView!
    @IBOutlet weak var swapToTokenTokenAbv: UILabel!
    @IBOutlet weak var swapToTokenAmountTextField: UITextField!
    @IBOutlet weak var swapToTokenSelectImage: UIImageView!
    @IBOutlet weak var swapToTokenSelectButton: UIButton!
    
    @IBOutlet weak var reviewButtonView: UIView!
    @IBOutlet weak var reviewButtonButton: UIButton!
    @IBOutlet weak var reviewButtonText: UILabel!
    
    var walletData = [WalletDataModel]()
    var selectedIndex = 0
    var selectedWallet = ""
    var swapFromTokenType: WalletType = .xe
    var swapToTokenType: WalletType = .xe
    var toIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let tbheight = self.tabBarController?.tabBar.frame.height ?? 49.0
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-((tbheight+topBarHeight)-1))
    }

    func configureViews() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.swapFromAmountTextField.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named:"PlaceHolderFont") ?? .white])
        self.swapFromAmountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func configureData() {
        
        self.walletData = WalletDataModelManager.shared.getWalletData()
        
        let address = WalletDataModelManager.shared.selectedWalletAddress
        self.selectedIndex = self.walletData.firstIndex(where: { $0.address == address }) ?? 0
        
        self.swapFromTokenType = self.walletData[self.selectedIndex].type
        if self.swapFromTokenType == .ethereum {
            
            self.swapFromTokenType = .edge
        }
        self.setToWalletDetails()
        self.configureSelectedWallet(clearValue: true)
    }
    
    func configureSelectedWallet(clearValue: Bool) {
        
        let wallet = self.walletData[self.selectedIndex]
        
        self.addressTokenImage.image = UIImage(named:wallet.type.rawValue)
        self.addressAddressLabel.text = wallet.address
        
        self.swapFromTokenImage.image = UIImage(named:wallet.type.rawValue)
        self.swapFromTokenAbv.text = wallet.type.getDataString(dataType: .displayLabel)
        
        if clearValue {
        
            self.swapFromAmountTextField.text = ""
        }
                
        if wallet.type == .xe {
            
            self.swapFromTokenImage.image = UIImage(named:wallet.type.rawValue)
            self.swapFromTokenAbv.text = wallet.type.getDataString(dataType: .coinSymbolLabel)
            self.swapFromAvailableLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: self.walletData[self.selectedIndex].status?.balance ?? 0)) XE available to swap"
            self.swapFromCardImage.image = UIImage(named:wallet.type.getDataString(dataType: .backgroundImage))
        } else {
            
            self.swapFromTokenImage.image = UIImage(named:self.swapFromTokenType.rawValue)
            self.swapFromTokenAbv.text = self.swapFromTokenType.getDataString(dataType: .coinSymbolLabel)
            var balance = "\(CryptoHelpers.generateCryptoValueString(value: self.walletData[self.selectedIndex].status?.balance ?? 0)) ETH available to swap"
            
            if self.swapFromTokenType == .edge {
                
                let edgeBalance = self.walletData[self.selectedIndex].status?.getTokenBalance(type: .edge)
                balance = "\(CryptoHelpers.generateCryptoValueString(value: edgeBalance ?? 0.0)) EDGE available to swap"
            }
            self.swapFromAvailableLabel.text = balance
            self.swapFromCardImage.image = UIImage(named:WalletType.ethereum.getDataString(dataType: .backgroundImage))
        }
        
        if self.toIndex != -1 {
        
            self.swapToTokenImage.image = UIImage(named:self.walletData[self.toIndex].type.rawValue)
            self.swapToAddressLabel.text = self.walletData[self.toIndex].address
            
            if self.walletData[self.toIndex].type == .xe {
                
                self.swapToTokenTokenImage.image = UIImage(named:self.walletData[self.toIndex].type.rawValue)
                self.swapToTokenTokenAbv.text = self.walletData[self.toIndex].type.getDataString(dataType: .displayLabel)
                
                self.swapToTokenSelectImage.isHidden = true
                self.swapToTokenSelectButton.isEnabled = false
                self.swapToCardImage.image = UIImage(named:WalletType.xe.getDataString(dataType: .backgroundImage))
            } else {
                
                self.swapToTokenSelectImage.isHidden = false
                self.swapToTokenSelectButton.isEnabled = true
                if self.swapToTokenType == .edge {
                    
                    self.swapToTokenTokenImage.image = UIImage(named:WalletType.edge.rawValue)
                    self.swapToTokenTokenAbv.text = WalletType.edge.getDataString(dataType: .displayLabel)
                } else if self.swapToTokenType == .usdc {
                        
                    self.swapToTokenTokenImage.image = UIImage(named:WalletType.usdc.rawValue)
                    self.swapToTokenTokenAbv.text = WalletType.usdc.getDataString(dataType: .displayLabel)
                } else {
                    
                    self.swapToTokenTokenImage.image = UIImage(named:WalletType.ethereum.rawValue)
                    self.swapToTokenTokenAbv.text = WalletType.ethereum.getDataString(dataType: .displayLabel)
                }
                self.swapToCardImage.image = UIImage(named:WalletType.ethereum.getDataString(dataType: .backgroundImage))
            }
        } else {
            
            self.swapToAddressLabel.text = "No Available Wallets"
            self.swapToTokenSelectButton.isHidden = true
            self.swapToTokenSelectButton.isEnabled = false
        }
        
        self.checkForActiveReviewButton()
    }
    
    func setToWalletDetails() {
        
        if self.walletData[self.selectedIndex].type == .xe {
        
            self.toIndex = self.findFirstIndex(type: .ethereum)
            self.swapToTokenType = .edge
        } else {
            
            self.toIndex = self.findFirstIndex(type: .xe)
            self.swapToTokenType = .xe
        }
    }
    
    func findFirstIndex(type: WalletType) -> Int{
        
        if let index = self.walletData.firstIndex(where: { $0.type == type }) {
            
            return index
        }
        return -1
    }
    
    func checkForActiveReviewButton() {
        
        var active = true
        
        if self.swapFromTokenType == .ethereum || self.swapToTokenType == .ethereum {
            
            active = false
        }
        
        let amountString:String = self.swapFromAmountTextField.text ?? "0.0"
        let amount: Double = Double(amountString) ?? 0.0
        if amount <= 0 {
            
            active = false
        }
        
        active = self.checkValidAmountSubFees(amount: amount)
        
        if active == false {
            
            self.reviewButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.reviewButtonText.textColor = UIColor(named:"FontSecondary")
            self.reviewButtonButton.isEnabled = false
        } else {
            
            self.reviewButtonView.backgroundColor = UIColor(named:"XEGreen")
            self.reviewButtonText.textColor = UIColor(named:"FontMain")
            self.reviewButtonButton.isEnabled = true
        }
    }
    
    func checkValidAmountSubFees(amount: Double) -> Bool {
        
        if self.swapToTokenType == .usdc {
            
            let rates = XEExchangeRatesManager.shared.getRates()

            let rate = XEExchangeRatesManager.shared.getRateValue()
            if amount <= 0 || amount > rates?.limit ?? 100 {
                
                return false
            }
            return true

        } else {
            
            if let gas = XEGasRatesManager.shared.getRates() {
                
                let fee: Double = Double(gas.fee)
                var handling: Double = ((amount)/100) * gas.handlingFeePercentage
                if handling < 25 {
                    
                    handling = 25
                }
                let totalFee = fee + handling
                
                if amount - totalFee > 0 {
                    
                    return true
                }
            }
        }
        return false
    }
    
    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    
    @IBAction func addressSelectButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "ExchangeWalletSelectionViewController") as! ExchangeWalletSelectionViewController
            contentVC.delegate = self
            contentVC.titleString = "Select Wallet"
            contentVC.walletData = self.walletData
            contentVC.type = .wallet
            contentVC.tag = 0
            self.presentPanModal(contentVC)
        }
    }
    
    @IBAction func swapFromTokenSelectionButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "ExchangeWalletSelectionViewController") as! ExchangeWalletSelectionViewController
            contentVC.delegate = self
            contentVC.titleString = "Select Token"
            contentVC.walletData = self.walletData
            contentVC.type = .token
            contentVC.selectedWalletIndex = self.selectedIndex
            contentVC.tag = 1
            self.presentPanModal(contentVC)
        }
    }
    
    @IBAction func swapFromMaxButtonPressed(_ sender: Any) {
        
        if self.swapFromTokenType == .edge {
        
            let edgeBalance = self.walletData[self.selectedIndex].status?.getTokenBalance(type: .edge)
            self.swapFromAmountTextField.text = CryptoHelpers.generateCryptoValueString(value: edgeBalance ?? 0)
        } else {
            
            self.swapFromAmountTextField.text = CryptoHelpers.generateCryptoValueString(value: self.walletData[self.selectedIndex].status?.balance ?? 0)
        }
    }
    
    @IBAction func swapToSelectButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "ExchangeWalletSelectionViewController") as! ExchangeWalletSelectionViewController
            contentVC.delegate = self
            contentVC.titleString = "Select Wallet"
        
            if self.walletData[self.selectedIndex].type == .xe {
            
                contentVC.walletData = self.walletData.filter { $0.type != .xe }
            } else {
            
                contentVC.walletData = self.walletData.filter { $0.type == .xe }
            }
            contentVC.type = .wallet
            contentVC.tag = 2
            self.presentPanModal(contentVC)
        }
    }
    
    @IBAction func swapToTokenSelectButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "ExchangeWalletSelectionViewController") as! ExchangeWalletSelectionViewController
            contentVC.delegate = self
            contentVC.titleString = "Select Token"
            contentVC.walletData = self.walletData
            contentVC.type = .token
            contentVC.selectedWalletIndex = self.toIndex
            contentVC.tag = 3
            self.presentPanModal(contentVC)
        }
    }
    
    @IBAction func swapToTokenMaxButtonPressed(_ sender: Any) {
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        self.checkForActiveReviewButton()
    }
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "ExchangeWalletReviewViewController") as! ExchangeWalletReviewViewController
            contentVC.fromAddress = self.walletData[self.selectedIndex]
            contentVC.fromType = self.swapFromTokenType
            let amountString:String = self.swapFromAmountTextField.text ?? "0.0"
            contentVC.fromAmount = Double(amountString) ?? 0.0
            contentVC.toAddress = self.walletData[self.toIndex]
            contentVC.totype = self.swapToTokenType
            self.presentPanModal(contentVC)
        }
    }
}

extension ExchangeViewController2 {
    
    func setSelectedData(tag: Int, data: String) {
        
        switch(tag) {
            
        case 0:
            if let index = self.walletData.firstIndex(where: { $0.address == data }) {
                
                self.selectedIndex = index
                self.swapFromTokenType = self.walletData[self.selectedIndex].type
                if self.swapFromTokenType == .ethereum {
                    
                    self.swapFromTokenType = .edge
                }
                self.setToWalletDetails()
                self.configureSelectedWallet(clearValue: true)
            }
            break
            
        case 1:
            if data == "Ethereum" {
                
                self.swapFromTokenType = .ethereum
            } else {
                
                self.swapFromTokenType = .edge
            }
            self.configureSelectedWallet(clearValue: true)
            break
            
        case 2:
            if let index = self.walletData.firstIndex(where: { $0.address == data }) {
                
                self.toIndex = index
                self.swapToTokenType = self.walletData[self.toIndex].type
                self.configureSelectedWallet(clearValue: false)
            }
            break
            
        case 3:
            if data == "Ethereum" {
                
                self.swapToTokenType = .ethereum
            } else if data == "Edge" {
                
                self.swapToTokenType = .edge
            } else {
                
                self.swapToTokenType = .usdc
            }
            self.configureSelectedWallet(clearValue: false)
            break
        default:
            break
        }
    }
}
