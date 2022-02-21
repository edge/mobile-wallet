//
//  ExchangeWalletCompleteViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 18/02/2022.
//

import UIKit
import PanModal

class ExchangeWalletCompleteViewController: BaseViewController {

    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.configureViews()
        self.configureTableViewArray()
        self.showSpinner(onView: self.view)
        
        self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.timer != nil {
            
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    func configureViews() {
    }
    
    func configureTableViewArray() {
    }
        
    @objc func fireTimer() {

        self.performSegue(withIdentifier: "unwindToWallet", sender: self)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
}

extension ExchangeWalletCompleteViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .contentHeight(520)  }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
