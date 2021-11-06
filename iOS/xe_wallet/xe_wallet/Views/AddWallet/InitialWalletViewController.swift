//
//  InitialWalletViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/10/2021.
//

import UIKit

class InitialWalletViewController: BaseViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}
