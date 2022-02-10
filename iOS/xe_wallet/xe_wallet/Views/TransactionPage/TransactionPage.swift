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
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var transactionData: TransactionRecordDataModel? = nil
    var walletType: WalletType = .ethereum
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let type = transactionData?.type {
        
            self.walletType = type
        }
        
        self.tokenIconImage.image = UIImage(named: self.walletType.rawValue)
        self.tokenAmountLabel.text =  CryptoHelpers.generateCryptoValueString(value: self.transactionData?.amount ?? 0)
        self.tokenAbvLabel.text = self.walletType.getCoinSymbol()
        self.fromAddressLabel.text = self.transactionData?.sender
        self.toAddressLabel.text = self.transactionData?.recipient
        let date = Date(timeIntervalSince1970:TimeInterval(self.transactionData?.timestamp ?? 0))
        self.dateLabel.text = date.timeAgoDisplay()
    }

    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func exploreButtonPressed(_ sender: Any) {
        
        if let url = URL(string: "https://etherscan.io/tx/0xae5631210fa01945879d06b7dee6ace38ab89f9a7be98f98b545cf0f9db486e9") {
            
            UIApplication.shared.open(url)
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
