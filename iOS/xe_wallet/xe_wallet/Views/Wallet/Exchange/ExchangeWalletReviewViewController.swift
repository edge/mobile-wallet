//
//  ExchangeWalletReviewViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 17/02/2022.
//

import UIKit
import PanModal

class ExchangeWalletReviewViewController: BaseViewController {

    @IBOutlet weak var secondTimerLabel: UILabel!
    
    var timer:Timer?
    var timerCount = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.configureViews()
        self.configureTableViewArray()
        
        self.timerCount = 30
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func configureViews() {
        
    }
    
    func configureTableViewArray() {

    }
    
    @objc func fireTimer() {

        self.timerCount-=1
        self.secondTimerLabel.text = String(format: "%.2f", Double(self.timerCount)/100)
        
        if self.timerCount <= 5 {
            
            self.secondTimerLabel.textColor = .red
        } else {
            
            self.secondTimerLabel.textColor = UIColor(named: "FontMain")
        }
        
        
        if self.timerCount == 0 {
            
            self.timerCount = 30
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
}

extension ExchangeWalletReviewViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .contentHeight(520)  }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
