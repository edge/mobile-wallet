//
//  ManageDetailsViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/01/2022.
//

import UIKit
import PanModal

enum ManageDetailsStatus {
    
    case buttons
    case pin
    
    var height: PanModalHeight {
        switch self {
            case .buttons: return .contentHeight(340)
            case .pin: return .contentHeight(612)
        }
    }
}

protocol ManageDetailsViewControllerDelegate: AnyObject {
    
    func walletDeleted()
}

class ManageDetailsViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var backedupLabel: UILabel!
    
    @IBOutlet weak var deleteButtonView: UIView!
    @IBOutlet weak var deleteButtonText: UILabel!
    @IBOutlet weak var deleteButtonButton: UIButton!
    
    @NibWrapped(PinEntryView.self)
    @IBOutlet var pinEntryView: UIView!
    @IBOutlet weak var textEntryTextView: UITextField!
    @IBOutlet weak var pinEntryMainView: UIView!
    
    var data: WalletDataModel? = nil
    var delegate: ManageDetailsViewControllerDelegate? = nil
    
    var status: ManageDetailsStatus = .buttons
    var entered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.addressLabel.text = self.data?.address
        self.createdLabel.text = DateFunctions.getFormattedDateString(timeSince: Double(data?.created ?? 0))
        self.backedupLabel.text = DateFunctions.getFormattedDateString(timeSince: Double(data?.backedup ?? 0))
        
        self.buttonView.isHidden = false
        self.pinEntryMainView.isHidden = true
        
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
        textEntryTextView.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.status = .buttons
        _pinEntryView.unwrapped.setBoxesUsed(amt: 0)
        self.textEntryTextView.text = ""
        
        self.checkRemoveButton()
    }
    
    @IBAction func backupButtonPressed(_ sender: Any) {
        
        BiometricsManager().authenticateUser(completion: { [weak self] (response) in
            switch response {
                
            case .failure:
                DispatchQueue.main.async {
                    
                    self?.status = .pin
                    self?.panModalSetNeedsLayoutUpdate()
                    self?.panModalTransition(to: .shortForm)
                    self?.textEntryTextView.becomeFirstResponder()
                    self?.buttonView.isHidden = true
                    self?.pinEntryMainView.isHidden = false
                }
            case .success:
                DispatchQueue.main.async {
                    
                    let contentVC = UIStoryboard(name: "Manage", bundle: nil).instantiateViewController(withIdentifier: "ManageBackupViewController") as! ManageBackupViewController
                    contentVC.data = self?.data
                    contentVC.delegate = self
                    self?.presentPanModal(contentVC)
                }
            }
        })
        
        

        
        /*DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Manage", bundle: nil).instantiateViewController(withIdentifier: "ManageBackupViewController") as! ManageBackupViewController
            contentVC.data = self.data
            self.presentPanModal(contentVC)
        }*/
    }
    
    func checkRemoveButton() {
        
        if let wallet = self.data {
            
            if wallet.type == .xe {
                
                if WalletDataModelManager.shared.getAmountOfWalletsForType(type:.xe) == 1 {
                    
                    self.deleteButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
                    self.deleteButtonText.textColor = UIColor(named:"FontSecondary")
                    self.deleteButtonButton.isEnabled = false
                    return
                }
            }
        }
        self.deleteButtonView.backgroundColor = .red
        self.deleteButtonText.textColor = .white
        self.deleteButtonButton.isEnabled = true
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        
        self.deleteTheWallet()
    }
    
    func deleteTheWallet() {
        
        let alert = UIAlertController(title: Constants.deleteWalletHeader, message: Constants.deleteWalletBody, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.buttonOkText, style: .default, handler: { action in

            WalletDataModelManager.shared.deleteWallet(address: self.data?.address ?? "")
            self.delegate?.walletDeleted()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: Constants.buttonCancelText, style: .default, handler: { action in

        }))
        self.present(alert, animated: true)
    
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {

        if let characters = textField.text?.count {
        
            _pinEntryView.unwrapped.setBoxesUsed(amt: characters)
            if characters >= AppDataModelManager.shared.appPinCharacterLength && self.entered == false {
                
                self.entered = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    if let code = textField.text {
                    
                        if AppDataModelManager.shared.getAppPinCode() == String(code.prefix(6)) {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                            
                                self.textEntryTextView.resignFirstResponder()
                                let contentVC = UIStoryboard(name: "Manage", bundle: nil).instantiateViewController(withIdentifier: "ManageBackupViewController") as! ManageBackupViewController
                                contentVC.data = self.data
                                contentVC.delegate = self
                                self.presentPanModal(contentVC)
                            }
                        } else {
                                                        
                            let alert = UIAlertController(title: Constants.confirmIncorrectPinMessageHeader, message: Constants.confirmIncorrectPinMessageBody, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: Constants.confirmIncorrectPinButtonText, style: .default, handler: { action in

                                self._pinEntryView.unwrapped.setBoxesUsed(amt: 0)
                                self.textEntryTextView.text = ""
                                self.entered = false
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
}

extension ManageDetailsViewController: ManageBackupViewControllerDelegate {
    
    func closeWindow() {
        
        self.status = .buttons
        panModalSetNeedsLayoutUpdate()
        panModalTransition(to: .shortForm)
        //self.textEntryTextView.resignFirstResponder()
        self.buttonView.isHidden = false
        self.pinEntryMainView.isHidden = true
    }
}

extension ManageDetailsViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    //var longFormHeight: PanModalHeight { return .contentHeight(340) }
    
    var shortFormHeight: PanModalHeight {
        
        return self.status.height
    }
    
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
