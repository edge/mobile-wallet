//
//  SendSelectTokenViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 22/01/2022.
//

import UIKit
import PanModal


protocol SendSelectTokenViewControllerDelegate {
    
    func setSelectedAsset(type: WalletType)
}

class SendSelectTokenViewController: BaseViewController {
    
    @IBOutlet weak var etherAmountLabel: UILabel!
    @IBOutlet weak var edgeAmountLabel: UILabel!
    
    var delegate: SendSelectTokenViewControllerDelegate?
    var etherAmount = ""
    var edgeAmount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.etherAmountLabel.text = self.etherAmount
        self.edgeAmountLabel.text = self.edgeAmount
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectionButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            self.delegate?.setSelectedAsset(type: .ethereum)
        } else if sender.tag == 1 {
            
            self.delegate?.setSelectedAsset(type: .edge)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension SendSelectTokenViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .contentHeight(312)  }
    
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
