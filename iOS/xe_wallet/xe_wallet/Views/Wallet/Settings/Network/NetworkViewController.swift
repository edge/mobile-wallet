//
//  NetworkViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 04/11/2021.
//

import UIKit

class NetworkViewController: BaseViewController {
    
    @IBOutlet weak var mainNetHighlightView: UIView!
    @IBOutlet weak var testNetHighlightView: UIView!
    
    @IBOutlet weak var selectNetworkButtonView: UIView!
    @IBOutlet weak var selectNetworkButtonText: UILabel!
    
    @IBOutlet weak var mainnetTickImage: UIImageView!
    @IBOutlet weak var testnetTickImage: UIImageView!
    var testnetStatus: NetworkState = .test
    var testnetStatusStart: NetworkState = .test
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.testnetStatus = AppDataModelManager.shared.testModeStatus()
        self.testnetStatusStart = self.testnetStatus
    
        self.setButtonStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.title = AppDataModelManager.shared.getNetworkStatus().rawValue
        //getNetworkTitleString()
    }
    
    @objc func backTapped(sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainNetButtonPressed(_ sender: Any) {
        
        self.testnetStatus = .main
        self.setButtonStatus()
    }
    
    @IBAction func testNetButtonPressed(_ sender: Any) {
        
        self.testnetStatus = .test
        self.setButtonStatus()
    }
    
    @IBAction func selectNetworkButtonPressed(_ sender: Any) {
        
        if self.testnetStatus != self.testnetStatusStart {
            
            var networkText = NetworkState.test.rawValue
            if AppDataModelManager.shared.getNetworkStatus() == .test {
                
                networkText = NetworkState.main.rawValue
            }

            let alert = UIAlertController(title: Constants.networkChangeConfirmMessageHeader , message: "\(Constants.networkChangeConfirmMessage) \(networkText)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.buttonOkText, style: .default, handler: { action in
                
                AppDataModelManager.shared.statusToggle()
                WalletDataModelManager.shared.switchedWallets()

                self.performSegue(withIdentifier: "unwindToWalletView", sender: self)
                //self.dismiss(animated: true, completion: nil)
                
            }))
            alert.addAction(UIAlertAction(title: Constants.buttonCancelText, style: .default, handler: { action in
                
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }
    }
    
    func setButtonStatus() {
        
        if self.testnetStatus == .test {
        
            self.mainNetHighlightView.backgroundColor = UIColor(named: "BackgroundMain")
            self.testNetHighlightView.backgroundColor = UIColor(named: "ButtonGreen")
            self.testnetTickImage.isHidden = false
            self.mainnetTickImage.isHidden = true
        } else {
            
            self.mainNetHighlightView.backgroundColor = UIColor(named: "ButtonGreen")
            self.testNetHighlightView.backgroundColor = UIColor(named: "BackgroundMain")
            self.testnetTickImage.isHidden = true
            self.mainnetTickImage.isHidden = false

        }
        
        if self.testnetStatus != self.testnetStatusStart {

            self.selectNetworkButtonText.textColor = UIColor(named: "FontMain")
            self.selectNetworkButtonView.backgroundColor = UIColor(named:"ButtonGreen")
        } else {
            
            self.selectNetworkButtonText.textColor = UIColor(named: "ButtonTextInactive")
            self.selectNetworkButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
        }
    }
}
