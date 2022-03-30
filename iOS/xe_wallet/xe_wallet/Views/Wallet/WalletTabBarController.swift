//
//  WalletTabViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/03/2022.
//

import Foundation
import UIKit


class WalletTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        //NotificationCenter.default.addObserver(self, selector: #selector(appAppearedFromBackground), name: .appEnteredForeground, object: nil)
        
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func appAppearedFromBackground() {
        
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

