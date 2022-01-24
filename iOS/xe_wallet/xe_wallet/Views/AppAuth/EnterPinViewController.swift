//
//  EnterPinViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit

class EnterPinViewController: UIViewController {

    @NibWrapped(PinEntryView.self)
    @IBOutlet var pinEntryView: UIView!
    
    @IBOutlet weak var textEntry: UITextField!
    var entered = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _pinEntryView.unwrapped.setBoxesUsed(amt: 0)
        
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
        textEntry.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        textEntry.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let story = UIStoryboard(name: "Wallet", bundle:nil)
        //let vc = story.instantiateViewController(withIdentifier: "WalletNavigationController") as! UINavigationController
        let vc = story.instantiateViewController(withIdentifier: "WalletNavigationController") as! UITabBarController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        if let characters = textField.text?.count {
        
            _pinEntryView.unwrapped.setBoxesUsed(amt: characters)
            
            if characters >= AppDataModelManager.shared.appPinCharacterLength && self.entered == false {
                
                self.entered = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    if let code = textField.text {
                    
                        if AppDataModelManager.shared.checkPinCode(code: String(code.prefix(6))) {
                            
                            DispatchQueue.main.async {

                                let story = UIStoryboard(name: "Wallet", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "WalletNavigationController") as! UITabBarController
                                //let vc = story.instantiateViewController(withIdentifier: "WalletNavigationController") as! UINavigationController
                                UIApplication.shared.windows.first?.rootViewController = vc
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                            }
                        } else {
                            
                            let alert = UIAlertController(title: Constants.enterIncorrectPinMessageHeader, message: Constants.enterIncorrectPinMessageBody, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: Constants.enterIncorrectPinButtonText, style: .default, handler: { action in

                                LoginDataModelManager.shared.increaseLoginAttemts()
                                self.textEntry.text = ""
                                self._pinEntryView.unwrapped.setBoxesUsed(amt: 0)
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
