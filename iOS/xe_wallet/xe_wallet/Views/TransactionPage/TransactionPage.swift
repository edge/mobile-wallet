//
//  TransactionPage.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/01/2022.
//

import UIKit
import PanModal

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
    
    @IBOutlet weak var exploreButtonLabel: UILabel!
    
    var transactionData: TransactionRecordDataModel? = nil
    var walletType: WalletType = .ethereum
    var walletAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let transaction = self.transactionData {
            
            self.walletType = transaction.type ?? .ethereum
            
            self.tokenIconImage.image = UIImage(named: self.walletType.rawValue)
            
            if self.walletAddress.lowercased() == transaction.sender.lowercased() {
                
                if transaction.confirmations ?? 0 >= 10 {
                    
                    self.directionLabel.text = "Sent"
                } else {
                    
                    self.directionLabel.text = "Sending"
                }
            } else {
                
                if transaction.confirmations ?? 0 >= 10 {
                    
                    self.directionLabel.text = "Received"
                } else {
                    
                    self.directionLabel.text = "Receiving"
                }
            }
                
            self.tokenAmountLabel.text =  CryptoHelpers.generateCryptoValueString(value: transaction.amount)
            self.tokenAbvLabel.text = self.walletType.getCoinSymbol()
                
            self.toTokenImage.image = UIImage(named: self.walletType.rawValue)
            self.toAddressLabel.text = transaction.recipient
                
            self.fromTokenImage.image = UIImage(named: self.walletType.rawValue)
            self.fromAddressLabel.text = transaction.sender
                
            if transaction.confirmations ?? 0 >= 10 {
                
                let date = Date(timeIntervalSince1970:TimeInterval(transaction.timestamp ?? 0))
                self.dateLabel.text = date.timeAgoDisplay()
            } else {
                
                self.dateLabel.text = "Pending"
            }
            
            self.exploreButtonLabel.text = transaction.type?.getExploreButtonText()
        }
    }

    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func exploreButtonPressed(_ sender: Any) {
        
        if let transaction = self.transactionData {
         
            if let end = transaction.type?.getExploreButtonUrl() {
                
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
    var longFormHeight: PanModalHeight { return .contentHeight(552) }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
