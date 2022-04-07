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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CreateWalletViewController" {
            
            let controller = segue.destination as! CreateWalletViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.type = .xe
        }
        
        if segue.identifier == "RestoreWalletViewController" {
            
            let controller = segue.destination as! RestoreWalletViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.type = .xe
        }
    }
    
    @IBAction func createWalletButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "CreateWalletViewController", sender: nil)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "RestoreWalletViewController", sender: nil)
    }
}
