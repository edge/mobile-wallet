//
//  ManageViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import UIKit

class ManageViewController: BaseViewController, UITableViewDelegate,  UITableViewDataSource, ManageTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    var walletTableViewData = [WalletDataModel]()
    
    let tableViewCellHeight:CGFloat = 68
    var selectedIndex: Int?
    
    let tableViewCellHeightClosed: CGFloat = 56
    let tableViewCellHeightOpen: CGFloat = 256

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.walletTableViewData = WalletDataModelManager.shared.getWalletData()
        
        self.tableView.isEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = AppDataModelManager.shared.getNetworkTitleString()
    }
}

extension ManageViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.walletTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        if selectedIndex == indexPath.row {
            
            //self.tableView.isEditing = false
            return tableViewCellHeightOpen
        }
        return tableViewCellHeightClosed
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageTableViewCell", for: indexPath)
        
        (cell as? ManageTableViewCell)?.configure(data: self.walletTableViewData[indexPath.row])
        (cell as? ManageTableViewCell)?.delegate = self
        
        cell.overrideUserInterfaceStyle = .dark
        cell.selectionStyle = .none
        cell.layer.borderColor = UIColor(named:"BackgroundMain")?.cgColor
        cell.layer.borderWidth = 4
        return cell
    }
        
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        WalletDataModelManager.shared.switchWalletPosition(aIndex: sourceIndexPath.row, bIndex: destinationIndexPath.row)
        
        let movedObject = self.walletTableViewData[sourceIndexPath.row]
        self.walletTableViewData.remove(at: sourceIndexPath.row)
        self.walletTableViewData.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.isEditing = true
        if selectedIndex == indexPath.row {
            
            self.selectedIndex = nil
        } else {
            
            self.selectedIndex = indexPath.row
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension ManageViewController {
    
    func backupButtonPressed(address: String) {
        let a = address
        let b = a
    }
    
    func removeButtonPressed(address: String) {
        let a = address
        let b = a
    }
}

