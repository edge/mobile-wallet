//
//  ManageBackupViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 06/02/2022.
//

import UIKit
import PanModal

class ManageBackupViewController: BaseViewController {

    @IBOutlet weak var walletAddressLabel: UILabel!
    @IBOutlet weak var privateKeyLabel: UILabel!
    
    var data: WalletDataModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let wallet = data {
        
            self.walletAddressLabel.text = wallet.address
            self.privateKeyLabel.text = WalletDataModelManager.shared.loadWalletKey(key:wallet.address)
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
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension ManageBackupViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .contentHeight(340) }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
