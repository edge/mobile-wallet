//
//  ConfirmPinViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit
import Security

class ConfirmPinViewController: UIViewController {

    @NibWrapped(PinEntryView.self)
    @IBOutlet var pinEntryView: UIView!
    
    @IBOutlet weak var textEntry: UITextField!
    
    var pinCode:String = ""
    var entered = false
    
    let incorrectPinMessageHeader = "Incorrect PIN"
    let incorrectPinMessageBody = "The PIN does not match previously entered PIN.  Please try again"
    let incorrectPinButtonText = "Retry"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _pinEntryView.unwrapped.setBoxesUsed(amt: 0)
        
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
        textEntry.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        textEntry.becomeFirstResponder()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {

        if let characters = textField.text?.count {
        
            _pinEntryView.unwrapped.setBoxesUsed(amt: characters)
            if characters >= AppDataModelManager.shared.appPinCharacterLength && self.entered == false {
                
                self.entered = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    if let code = textField.text {
                    
                        if self.pinCode == String(code.prefix(6)) {
                            
                            DispatchQueue.main.async {
                                
                                let username = "xewalletpincode"
                                let password = self.pinCode.data(using: .utf8)!

                                let attributes: [String: Any] = [
                                    kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: username,
                                    kSecValueData as String: password,
                                ]

                                if SecItemAdd(attributes as CFDictionary, nil) == noErr {
                                    
                                    let story = UIStoryboard(name: "Wallet", bundle:nil)
                                    let vc = story.instantiateViewController(withIdentifier: "WalletNavigationController") as! UINavigationController
                                    UIApplication.shared.windows.first?.rootViewController = vc
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                } else {

                                    let alert = UIAlertController(title: self.incorrectPinMessageHeader, message: self.incorrectPinMessageBody, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: self.incorrectPinButtonText, style: .default, handler: { action in

                                        self.performSegue(withIdentifier: "UnwindToPinEntry", sender: self)
                                    }))
                                    self.present(alert, animated: true)
                                }
                            }
                        } else {
                                                        
                            let alert = UIAlertController(title: self.incorrectPinMessageHeader, message: self.incorrectPinMessageBody, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: self.incorrectPinButtonText, style: .default, handler: { action in

                                self.performSegue(withIdentifier: "UnwindToPinEntry", sender: self)
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
}
