//
//  CreatePinViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit

class CreatePinViewController: UIViewController {

    @NibWrapped(PinEntryView.self)
    @IBOutlet var pinEntryView: UIView!
    
    @IBOutlet weak var textEntry: UITextField!
    
    var pinCode = ""
    var entered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _pinEntryView.unwrapped.setBoxesUsed(amt: 0)
        
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
        textEntry.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        textEntry.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _pinEntryView.unwrapped.setBoxesUsed(amt: 0)
        self.textEntry.text = ""
        textEntry.becomeFirstResponder()
        self.entered = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is ConfirmPinViewController {
            
            let vc = segue.destination as? ConfirmPinViewController
            vc?.pinCode = String(self.pinCode.prefix(6))
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        if let characters = textField.text?.count {
        
            _pinEntryView.unwrapped.setBoxesUsed(amt: characters)
            if characters >= AppDataModelManager.shared.appPinCharacterLength && self.entered == false {

                self.entered = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    if let code = textField.text {
                    
                        self.pinCode = code
                        self.performSegue(withIdentifier: "ShowConfirmPinViewController", sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToPinEntry(sender: UIStoryboardSegue) {

    }
}
