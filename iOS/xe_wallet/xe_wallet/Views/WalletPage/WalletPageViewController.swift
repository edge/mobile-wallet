//
//  WalletPageViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/01/2022.
//

import UIKit
import PanModal

class WalletPageViewController: BaseViewController{

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.configureViews()
    }

    func configureViews() {
        
        self.segmentedControl.backgroundColor = UIColor.black
        self.segmentedControl.selectedSegmentTintColor = UIColor(named: "PinEntryBoxBackground")
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "Inter-Medium", size: 14.0)!,
            NSAttributedString.Key.foregroundColor: UIColor(named:"FontSecondary")
        ]
        self.segmentedControl.setTitleTextAttributes(defaultAttributes, for: .normal)
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "Inter-Medium", size: 14.0)!,
            NSAttributedString.Key.foregroundColor: UIColor(named:"FontMain")
        ]
        self.segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }

}


extension WalletPageViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .maxHeightWithTopInset(40) }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}

