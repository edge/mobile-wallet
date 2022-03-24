//
//  TransactionPage.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/01/2022.
//

import UIKit
import PanModal
import web3swift


enum TransactionPageViewControllerHeights {
    
    case xe
    case other
    
    var height: PanModalHeight {
        switch self {
            case .xe: return .contentHeight(609)
            case .other: return .contentHeight(609)
        }
    }
}

class TransactionPageViewController: BaseViewController{

    @IBOutlet weak var tokenIconImage: UIImageView!
    @IBOutlet weak var tokenAmountLabel: UILabel!
    @IBOutlet weak var tokenAbvLabel: UILabel!
    @IBOutlet weak var toTokenImage: UIImageView!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var fromTokenImage: UIImageView!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var statusTickImage: UIImageView!
    
    @IBOutlet weak var exploreButtonLabel: UILabel!
    
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var memoTextLabel: UITextField!
    
    @IBOutlet weak var memoHeadingLabel: UILabel!
    
    var transactionData: TransactionDataModel? = nil
    var walletType: WalletType = .ethereum
    var walletAddress = ""
    var viewHeight: TransactionPageViewControllerHeights = .other
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let transaction = self.transactionData {
            
            self.walletType = transaction.type ?? .ethereum
            
            self.tokenIconImage.image = UIImage(named: self.walletType.rawValue)
            
            if transaction.status == .pending {
                
                self.statusTickImage.image = UIImage(named:"clock")
                self.statusTickImage.tintColor = UIColor(named:"FontSecondary")
                
                let date = Date(timeIntervalSince1970:TimeInterval(transaction.timestamp ?? 0))
                self.directionLabel.text = "Pending for \(date.timeAgoDisplay())"
                self.directionLabel.textColor = UIColor(named:"FontSecondary")
                self.dateLabel.isHidden = true
            } else {
                
                if transaction.confirmations ?? 0 < 10 {
                
                    self.statusTickImage.image = UIImage(named:"clock")
                    self.statusTickImage.tintColor = UIColor(named:"FontSecondary")
                    if let confirmations = transaction.confirmations {
                    
                        if confirmations == 1 {
                            
                            self.directionLabel.text = "\(confirmations) confirmation"
                        } else {
                            
                            self.directionLabel.text = "\(confirmations) confirmations"
                        }
                    }
                    self.directionLabel.textColor = UIColor(named:"FontSecondary")
                } else {
                    
                    self.statusTickImage.image = UIImage(named:"xetick")
                    self.statusTickImage.tintColor = UIColor(named:"FontMain")
                    self.directionLabel.textColor = UIColor(named:"XEGreen")
                    
                    self.directionLabel.text = "Confirmed"
                }
                
                self.dateLabel.isHidden = false
                let date = Date(timeIntervalSince1970:TimeInterval(transaction.timestamp ?? 0))
                self.dateLabel.text = date.timeAgoDisplay()
                self.dateLabel.isHidden = false
            }
             
            if walletType == .xe {
                
                self.memoView.isHidden = false
                self.memoViewHeightConstraint.constant = 77
                
                var memoString = "None"
                if let memo = transaction.data?.memo {
                    
                    if memo.count > 0 {
                        
                        memoString = memo
                    }
                }
                self.memoTextLabel.text = memoString
                self.viewHeight = .xe
                self.memoHeadingLabel.text = "Memo"
                
                panModalSetNeedsLayoutUpdate()
                
            } else {
                
                let infura = EtherWallet().getAPIKey(keyName: "infura")
                
                var web3 = Web3.InfuraMainnetWeb3(accessToken: infura)
                if AppDataModelManager.shared.testModeStatus() == .test {
                    
                    web3 = Web3.InfuraRinkebyWeb3(accessToken: infura)
                }
                
                self.memoView.isHidden = false
                self.memoViewHeightConstraint.constant = 77
                self.viewHeight = .other
                panModalSetNeedsLayoutUpdate()
                
                self.memoHeadingLabel.text = "Fee"
                if let gas = self.transactionData?.gas {
                
                    let price = (Double(gas) ?? 0.0)/1000000000
                    let rate = Double(EtherExchangeRatesManager.shared.getRateValue()) * price
                    self.memoTextLabel.text = "\(CryptoHelpers.generateCryptoValueString(value: price)) Ether ($\(StringHelpers.generateValueString(value: Double(truncating: rate as! NSNumber))))"
                }
            }
            
            self.tokenAmountLabel.text =  CryptoHelpers.generateCryptoValueString(value: transaction.amount)
            self.tokenAbvLabel.text = self.walletType.getDataString(dataType: .coinSymbolLabel)
                
            
            self.toTokenImage.image = UIImage(named: self.walletType.rawValue)
            self.toAddressLabel.text = transaction.recipient
                
            self.fromTokenImage.image = UIImage(named: self.walletType.rawValue)
            self.fromAddressLabel.text = transaction.sender
            
            self.exploreButtonLabel.text = transaction.type?.getDataString(dataType: .explorerButtonText)
            

        }
    }

    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func exploreButtonPressed(_ sender: Any) {
        
        if let transaction = self.transactionData {
         
            if let end = transaction.type?.getDataNetwork(dataType: .exploreButtonUrl) {
                
                if let url = URL(string: "\(end)\(transaction.hash)") {
                    
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}



extension TransactionPageViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
//    var longFormHeight: PanModalHeight { return .contentHeight(552) }
    
    var shortFormHeight: PanModalHeight {
        
        return self.viewHeight.height
    }
    
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
