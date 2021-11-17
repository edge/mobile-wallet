//
//  SettingsViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 09/10/2021.
//

import UIKit

class SettingsViewController: BaseViewController, UITableViewDelegate,  UITableViewDataSource {

    let resetAppMessageHeader = "Reset App Data"
    let resetAppMessageBody = "This will remove all apps data including pins and wallets."
    let resetAppButtonOkText = "Ok"
    let resetAppButtonCancelText = "Cancel"
    
    var settingsMenuTableViewData = [SettingsDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.settingsMenuTableViewData = SettingsDataModelManager.shared.getSettingsData()
        
        self.title = AppDataModelManager.shared.getNetworkTitleString()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension SettingsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.settingsMenuTableViewData.count
    }
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return self.settingsMenuTableViewData[indexPath.row].type.getHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: self.settingsMenuTableViewData[indexPath.row].type.rawValue, for: indexPath)

        let data = self.settingsMenuTableViewData[indexPath.row]
        if data.type == .header {
            
            (cell as! SettingsHeaderTableViewCell).configure(data: data)
        } else {
            
            (cell as! SettingsMenuItemTableViewCell).configure(data: data)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch self.settingsMenuTableViewData[indexPath.row].linkDataType {
            
        case .header:
            break
        case .screen:
            self.performSegue(withIdentifier: self.settingsMenuTableViewData[indexPath.row].linkData, sender: nil)
            break
        case .web:
            if let url = URL(string: self.settingsMenuTableViewData[indexPath.row].linkData) {

                UIApplication.shared.open(url)
            }
            break
        case .popup:
            let type = self.settingsMenuTableViewData[indexPath.row].linkData
                
            if type == "ResetApp" {
                
                let alert = UIAlertController(title: self.resetAppMessageHeader, message: self.resetAppMessageBody, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: self.resetAppButtonOkText, style: .default, handler: { action in

                    KeychainHelper.logout()
                    let defaults = UserDefaults.standard
                    let dictionary = defaults.dictionaryRepresentation()
                    dictionary.keys.forEach { key in
                        
                        defaults.removeObject(forKey: key)
                    }
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: self.resetAppButtonCancelText, style: .default, handler: { action in

                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
                
                

            }
            break
        }
    }
}

