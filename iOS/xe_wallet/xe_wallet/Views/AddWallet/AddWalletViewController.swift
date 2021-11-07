//
//  AddWalletViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 02/11/2021.
//

import UIKit

class AddWalletViewController: BaseViewController {
        
    @IBOutlet weak var xeCircleView: UIView!
    @IBOutlet weak var xeInnerCircleView: UIView!
    @IBOutlet weak var etherCircleView: UIView!
    @IBOutlet weak var etherInnerCircleView: UIView!
    
    var selected:WalletType = .xe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = true
        self.title = "Add Wallet"
        
        self.configureSelectedButtons()
    }
    
    func configureSelectedButtons() {
        
        if self.selected == .xe {
            
            self.xeCircleView.backgroundColor = UIColor(named:"ButtonGreen")
            self.xeInnerCircleView.backgroundColor = UIColor(named:"ButtonGreen")
            self.etherCircleView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.etherInnerCircleView.backgroundColor = UIColor(named:"MainBlack")
        } else {
            
            self.xeCircleView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.xeInnerCircleView.backgroundColor = UIColor(named:"MainBlack")
            self.etherCircleView.backgroundColor = UIColor(named:"ButtonGreen")
            self.etherInnerCircleView.backgroundColor = UIColor(named:"ButtonGreen")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowSendViewController" {
            

        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func xeButtonPressed(_ sender: Any) {
        
        self.selected = .xe
        self.configureSelectedButtons()
    }
    
    @IBAction func etherButtonPressed(_ sender: Any) {
        
        self.selected = .ethereum
        self.configureSelectedButtons()
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ShowCreateWalletViewController", sender: nil)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ShowRestoreWalletViewController", sender: nil)
    }
}