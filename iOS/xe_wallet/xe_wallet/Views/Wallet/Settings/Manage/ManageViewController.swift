//
//  ManageViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 11/10/2021.
//

import UIKit

class ManageViewController: BaseViewController, UITableViewDelegate,  UITableViewDataSource, ManageDetailsViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var walletTableViewData = [WalletDataModel]()
    
    //let tableViewCellHeight:CGFloat = 52
    var selectedIndex: Int?
    
    //let tableViewCellHeightClosed: CGFloat = 56
    //let tableViewCellHeightOpen: CGFloat = 256

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.walletTableViewData = WalletDataModelManager.shared.getWalletData()
        
        tableView.tableFooterView = nil
        self.tableView.isEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.separatorColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let logoutBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(addWalletButtonPressed))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.walletTableViewData = WalletDataModelManager.shared.getWalletData()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.title = AppDataModelManager.shared.getNetworkStatus().rawValue // getNetworkTitleString()
    }
    
    @objc func addWalletButtonPressed() {

        performSegue(withIdentifier: "ShowAddWallet", sender: nil)
    }
    
    @objc func backTapped(sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
}

extension ManageViewController {
    
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.walletTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 56
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.overrideUserInterfaceStyle = .dark
        
        (cell as? ManageTableViewCell)?.configure(data: self.walletTableViewData[indexPath.section])
        return cell
    }
        
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        WalletDataModelManager.shared.switchWalletPosition(aIndex: sourceIndexPath.section, bIndex: destinationIndexPath.section)
        
        let movedObject = self.walletTableViewData[sourceIndexPath.section]
        self.walletTableViewData.remove(at: sourceIndexPath.section)
        self.walletTableViewData.insert(movedObject, at: destinationIndexPath.section)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Manage", bundle: nil).instantiateViewController(withIdentifier: "ManageDetailsViewController") as! ManageDetailsViewController
            contentVC.data = self.walletTableViewData[indexPath.section]
            contentVC.delegate = self
            self.presentPanModal(contentVC)
        }
    }
}

extension ManageViewController {
    
    func walletDeleted() {

        self.walletTableViewData = WalletDataModelManager.shared.getWalletData()
        self.tableView.reloadData()
    }
}


