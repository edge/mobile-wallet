//
//  TransactionPage.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/01/2022.
//

import UIKit
import PanModal

class TransactionPageViewController: BaseViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

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
    var longFormHeight: PanModalHeight { return .contentHeight(576) }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
