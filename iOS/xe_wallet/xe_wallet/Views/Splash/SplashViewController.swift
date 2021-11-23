//
//  SplashViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit
import Security

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ExchangeRatesManager.shared.configure()
        GasRatesManager.shared.configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    

        let username = "xewalletpincode"
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?

        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {

            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8)
            {
                
                AppDataModelManager.shared.setAppPinCode(pin: password)
                BiometricsManager().authenticateUser(completion: { [weak self] (response) in
                    switch response {
                    
                    case .failure:
                        DispatchQueue.main.async {
                            
                            self?.performSegue(withIdentifier: "ShowEnterPinViewController", sender: nil)
                        }
                    case .success:
                        DispatchQueue.main.async {

                            let story = UIStoryboard(name: "Wallet", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "WalletNavigationController") as! UINavigationController
                            UIApplication.shared.windows.first?.rootViewController = vc
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
                    }
                })
            }
        } else {

            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "ShowCreatePinViewController", sender: nil)
            }
        }
    }
}
