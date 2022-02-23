//
//  ManageDetailsViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/01/2022.
//

import UIKit
import PanModal

protocol ManageDetailsViewControllerDelegate: AnyObject {
    
    func walletDeleted()
}

class ManageDetailsViewController: BaseViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var backedupLabel: UILabel!
    
    var data: WalletDataModel? = nil
    var delegate: ManageDetailsViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.addressLabel.text = self.data?.address
        self.createdLabel.text = DateFunctions.getFormattedDateString(timeSince: Double(data?.created ?? 0))
        self.backedupLabel.text = DateFunctions.getFormattedDateString(timeSince: Double(data?.backedup ?? 0))
    }
    
    @IBAction func backupButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Manage", bundle: nil).instantiateViewController(withIdentifier: "ManageBackupViewController") as! ManageBackupViewController
            contentVC.data = self.data
            self.presentPanModal(contentVC)
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        
        if let wallet = self.data {
            
            if wallet.type == .xe {
                
                if WalletDataModelManager.shared.getXEWalletAmount() == 1 {
                    
                    let alert = UIAlertController(title: Constants.deleteLastXEWalletHeader, message: Constants.deleteLastXEWalletBody, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: Constants.buttonOkText, style: .default, handler: { action in
                        
                    }))
                    self.present(alert, animated: true)
                } else {
                    
                    self.deleteTheWallet()
                }
            } else {
                
                self.deleteTheWallet()
            }
        }
    }
    
    func deleteTheWallet() {
        
        WalletDataModelManager.shared.deleteWallet(address: self.data?.address ?? "")
        self.delegate?.walletDeleted()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension ManageDetailsViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .contentHeight(340) }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
