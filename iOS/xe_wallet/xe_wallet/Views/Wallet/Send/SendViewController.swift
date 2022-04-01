//
//  SendViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 14/10/2021.
//

import UIKit
import PanModal
import BigInt
import web3swift

enum SendViewEntryStatus {
    
    case none
    case value
    case to
    case memo
    
    var height: PanModalHeight {
        switch self {
            case .none: return .contentHeight(530)
            case .value: return .contentHeight(640)
            case .to: return .contentHeight(750)
            case .memo: return .contentHeight(760)
        }
    }
}

class SendViewController: BaseViewController, UITextFieldDelegate, SendConfirmViewControllerDelegate,  SendSelectTokenViewControllerDelegate, ScanQRCodeViewControllerDelegate {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var walletTotalLabel: UILabel!
    @IBOutlet weak var and1TokenLabel: UILabel!
    @IBOutlet weak var tokenSelectionView: UIView!
    @IBOutlet weak var tokenSelecttionButton: UIButton!
    @IBOutlet weak var tokenSelectionImage: UIImageView!
    
    
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!

    @IBOutlet weak var reviewButtonView: UIView!
    @IBOutlet weak var reviewButtonText: UILabel!
    
    @IBOutlet weak var cardBackgroundImage: UIImageView!
    @IBOutlet weak var coinIconImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var assetLabel: UILabel!
    
    @IBOutlet weak var sendTitleLabel: UILabel!
    
    var selectedWalletAddress = ""
    var walletData: WalletDataModel? = nil
    
    var cardFrame: CGRect? = nil
    var cardImage: UIImage? = nil
    
    var isReviewActive = false
    var entryStatus: SendViewEntryStatus = . none
    var selectedAsset: WalletType = .ethereum
    
    var etherAmount = ""
    var edgeAmount = ""
    
    var gasPrice = Double(0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.calculateGasPrice()
        self.configureData()
        self.configureViews()
        self.configureCardDisplay()

        self.entryStatus = .none
        
        self.configureReviewButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func calculateGasPrice() {
        
        self.walletData = WalletDataModelManager.shared.getSelectedWalletData(address: self.selectedWalletAddress)
        
        if self.walletData?.type == .xe {
            
            self.gasPrice = 0
        } else {
            
            let gas = XEGasRatesManager.shared.getRates()
            if let legacy = gas?.ethereum.legacy {
                
                let gasPrice = BigUInt(legacy)
                let gasLimit = BigUInt(21000)
                let gasCost = gasPrice * gasLimit
                
                self.gasPrice = Double(Web3.Utils.formatToEthereumUnits(gasCost, toUnits: .Gwei, decimals: 6)!) ?? 0.0
            }
        }
    }
    
    func configureData() {
        
        if let wallet = self.walletData {
                    
            self.cardBackgroundImage.image = UIImage(named:wallet.type.getDataString(dataType: .backgroundImage))
            self.addressLabel.text = wallet.address
            self.selectedWalletAddress = wallet.address
                        
            if let status = wallet.status {
                
                self.etherAmount = CryptoHelpers.generateCryptoValueString(value: Double(status.balance) )
                
                let edgeBalance = status.getTokenBalance(type: .edge)
                self.edgeAmount = CryptoHelpers.generateCryptoValueString(value: edgeBalance )
            }
            if wallet.type == .xe {
                
                self.walletTotalLabel.text = "\(self.etherAmount) XE"
                self.and1TokenLabel.isHidden = true
                self.tokenSelecttionButton.isHidden = true
                self.tokenSelectionImage.isHidden = true
                self.selectedAsset = .xe
                self.sendTitleLabel.text = "Send XE"
            } else {
                
                self.walletTotalLabel.text = "\(self.etherAmount) ETH"
                self.and1TokenLabel.text = "\(self.edgeAmount) EDGE"
                self.and1TokenLabel.isHidden = false
                self.tokenSelecttionButton.isHidden = false
                self.tokenSelectionImage.isHidden = false
                self.selectedAsset = .ethereum
                self.sendTitleLabel.text = "Send Ether"
            }
        }
    }
    
    func configureViews() {
        
        self.title = "Send"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name:"Inter-Medium", size:14), NSAttributedString.Key.foregroundColor : UIColor(named:"FontSecondary")]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name:"Inter-Medium", size:14), NSAttributedString.Key.foregroundColor : UIColor(named:"FontOptional")]
        let attributedString1 = NSMutableAttributedString(string:"Memo ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"(optional)", attributes:attrs2)
        attributedString1.append(attributedString2)
        self.memoLabel.attributedText = attributedString1

        self.memoTextField.attributedPlaceholder = NSAttributedString(
            string: "Leave a memo",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named:"PlaceHolderFont") ?? .white])
        self.amountTextField.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named:"PlaceHolderFont") ?? .white])
        
        self.toTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.amountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.memoTextField.addTarget(self, action: #selector(self.memoTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    func configureCardDisplay() {
        
        self.coinIconImage.image = UIImage(named: self.selectedAsset.rawValue)
        self.assetLabel.text = self.selectedAsset.getDataString(dataType: .displayLabel)
        self.amountTextField.text = ""
        self.toTextField.attributedPlaceholder = NSAttributedString(
            string: "\(self.selectedAsset.getDataString(dataType: .coinSymbolLabel)) wallet address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named:"PlaceHolderFont") ?? .white])
        self.checkForActiveContinueButton()
    }
    
    func configureReviewButton() {
        
        if self.isReviewActive {
            
            self.reviewButtonView.backgroundColor = UIColor(named:"XEGreen")
            self.reviewButtonText.textColor = UIColor(named: "FontMain")
        } else {
            
            self.reviewButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.reviewButtonText.textColor = UIColor(named: "ButtonTextInactive")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print(segue.destination)
        if segue.destination is ScanQRCodeViewController {
            
            let vc = segue.destination as? ScanQRCodeViewController
            vc?.delegate = self
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.closeWindow()
    }
    
    func closeWindow() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        textField.resignFirstResponder()
        
        self.entryStatus = .none
        panModalSetNeedsLayoutUpdate()
        panModalTransition(to: .shortForm)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField.tag == 0 {
            
            self.entryStatus = .value
        } else if textField.tag == 1 {
            
            self.entryStatus = .to
        } else {
            
            self.entryStatus = .memo
        }
        panModalSetNeedsLayoutUpdate()
        panModalTransition(to: .shortForm)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        self.checkForActiveContinueButton()
    }
    
    @objc func memoTextFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text {
            
            let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890-:$")
            var trimmedMemo =  String(text.filter {okayChars.contains($0) })
            textField.text = trimmedMemo
        }
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

    func checkForActiveContinueButton() {
        
        var shouldBeActive = false
        
        guard let amountText = self.amountTextField.text else { return }
        guard let toText = self.toTextField.text else { return }

        if amountText != "" {
            
            if let amountVal = Double(amountText) {

                if let wallet = self.walletData {
                    
                    if let status = wallet.status {
                    
                        var walletAmount = 0.0
                        if self.selectedAsset == .edge {
                            
                            walletAmount = status.getTokenBalance(type: .edge)
                                    
                        } else {
                            
                            walletAmount = status.balance
                        }
                        
                        
                        if amountVal >= self.selectedAsset.getMinSendValue() && amountVal <= Double(walletAmount - self.gasPrice) {
                            
                            shouldBeActive = true
                            
                            if toText.count != wallet.type.getWalletCharacterLength() || !toText.hasPrefix(self.selectedAsset.getDataString(dataType: .coinPrefix)) {
                                
                                shouldBeActive = false
                            }
                        }
                    }
                }
            }
        }
        
        if self.isReviewActive != shouldBeActive {
            
            self.isReviewActive = shouldBeActive
            self.configureReviewButton()
        }
    }

    @IBAction func pasteButtonPressed(_ sender: Any) {
        
        weak var pb: UIPasteboard? = .general
        guard let text = pb?.string else { return }
        self.toTextField.text = text
        self.checkForActiveContinueButton()
    }
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        
        if self.isReviewActive {
        
            //performSegue(withIdentifier: "ShowSendReviewViewController", sender: nil)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
            
                let contentVC = UIStoryboard(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "SendConfirmViewController") as! SendConfirmViewController

                contentVC.walletData = self.walletData
                //controller.delegate = self
                var toAddress = ""
                if let to = self.toTextField.text {
                    
                    toAddress = to
                }
                contentVC.toAddress = toAddress
                var amount = "0"
                if let amt = self.amountTextField.text {
                    
                    amount = amt
                }
                contentVC.amount = amount
                var memo = ""
                if let mem = self.memoTextField.text {
                    
                    memo = mem
                }
                
                //memo = memo.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")

                contentVC.memo = memo
                contentVC.fromAddress = self.walletData?.address ?? ""
                
                contentVC.walletType = self.selectedAsset
                contentVC.delegate = self
                self.presentPanModal(contentVC)
            }
        }
    }
    
    @IBAction func tokenSelectButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "SendSelectTokenViewController") as! SendSelectTokenViewController
            contentVC.delegate = self
            contentVC.etherAmount = self.etherAmount
            contentVC.edgeAmount = self.edgeAmount
            self.presentPanModal(contentVC)
        }
    }
    
    @IBAction func maxButtonPressed(_ sender: Any) {
        
        if let status = self.walletData?.status {
            
            if self.selectedAsset == .edge {
                
                let edgeBalance = status.getTokenBalance(type: .edge)
                self.amountTextField.text = "\(String(format: "%.6f", Double(edgeBalance) - Double(self.gasPrice)))"
            } else {
            
                self.amountTextField.text = "\(String(format: "%.6f", Double(status.balance) - Double(self.gasPrice)))"
            }
        }
        self.checkForActiveContinueButton()
    }
}

extension SendViewController {
    
    func killView() {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func setSelectedAsset(type: WalletType) {
        
        self.selectedAsset = type
        self.configureCardDisplay()
        self.sendTitleLabel.text = "Send \(type.getDataString(dataType: .displayLabel))"
    }
}

extension SendViewController {
    
    func setScannedText(text: String) {
        
        self.toTextField.text = text
        print(text)
    }
}

extension SendViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    //var longFormHeight: PanModalHeight { return .contentHeight(554)  }
    
    var shortFormHeight: PanModalHeight {
        
        return self.entryStatus.height
    }
    
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
