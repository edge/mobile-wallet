//
//  WalletViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit

class WalletViewController: BaseViewController, UITableViewDelegate,  UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    var transactionListViewData = [TransactionRecordDataModel]()
    var walletCollectionViewData = [WalletDataModel]()
    
    var selectedIndex: Int?
    var selectedWallet = 0
    
    let tableViewCellHeightClosed: CGFloat = 66
    let tableViewCellHeightOpen: CGFloat = 234
    
    let walletButtonSegues = ["ShowSendViewController","ShowReceiveViewController","ShowExchangeViewController" ]
    
    var collectionViewUpdating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                        
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
                
        self.walletCollectionViewData = WalletDataModelManager.shared.getWalletData()
        
        if WalletDataModelManager.shared.activeWalletAmount() == 0 {
            
            let vc = UIStoryboard.init(name: "AddWallet", bundle: Bundle.main).instantiateViewController(withIdentifier: "InitialWalletViewController") as? InitialWalletViewController
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        
        self.title = AppDataModelManager.shared.getNetworkTitleString()
        
        tableView.allowsSelectionDuringEditing = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.walletCollectionViewData = WalletDataModelManager.shared.getWalletData()
        self.tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        self.collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.reloadData()
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        
        self.walletCollectionViewData = WalletDataModelManager.shared.getWalletData()
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if segue.identifier == "ShowSendViewController" {
            
            let controller = segue.destination as! SendViewController
            controller.modalPresentationStyle = .overCurrentContext
            
            if let selectedCardCell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedWallet, section: 0)) as? WalletCollectionViewCell{
                
                controller.cardImage = selectedCardCell.getCardViewImage()
             }
            controller.walletData = self.walletCollectionViewData[self.selectedWallet]

            controller.selectedWalletAddress = self.walletCollectionViewData[self.selectedWallet].address
        }
        
        if segue.identifier == "ShowReceiveViewController" {
            
            let controller = segue.destination as! ReceiveViewController
            controller.modalPresentationStyle = .overCurrentContext
            
            if let selectedCardCell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedWallet, section: 0)) as? WalletCollectionViewCell{
                
                controller.cardImage = selectedCardCell.getCardViewImage()
             }
            
            controller.walletData = self.walletCollectionViewData[self.selectedWallet]
            controller.selectedWalletAddress = self.walletCollectionViewData[self.selectedWallet].address
        }
        
        if segue.identifier == "ShowExchangeDepositViewController" {
            
            let controller = segue.destination as! ExchangeDepositViewController
            controller.modalPresentationStyle = .overCurrentContext
            if let selectedCardCell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedWallet, section: 0)) as? WalletCollectionViewCell{
                
                controller.cardImage = selectedCardCell.getCardViewImage()
             }
            
            controller.walletData = self.walletCollectionViewData[self.selectedWallet]
        }
        
        if segue.identifier == "ShowExchangeWithdrawViewController" {
            
            let controller = segue.destination as! ExchangeWithdrawViewController
            controller.modalPresentationStyle = .overCurrentContext
            if let selectedCardCell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedWallet, section: 0)) as? WalletCollectionViewCell{
                
                controller.cardImage = selectedCardCell.getCardViewImage()
             }
            
            controller.walletData = self.walletCollectionViewData[self.selectedWallet]
        }
        
        
    }
    
    @IBAction func walletButtonPressed(_ sender: UIButton) {
        
        if !self.collectionViewUpdating {
        
            switch sender.tag {
                
            case 0:
                performSegue(withIdentifier: "ShowSendViewController", sender: nil)
            case 1:
                performSegue(withIdentifier: "ShowReceiveViewController", sender: nil)
            case 2:
                if self.walletCollectionViewData[self.selectedWallet].type == .xe {
                    
                    performSegue(withIdentifier: "ShowExchangeDepositViewController", sender: nil)
                } else {
                 
                    performSegue(withIdentifier: "ShowExchangeWithdrawViewController", sender: nil)
                }
            default: break
            }
        }
    }
    
    @IBAction func unwindToWalletView(sender: UIStoryboardSegue) {

    }
    
    @IBAction func addWalletButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ShowAddWalletViewController", sender: nil)
    }
    
}

extension WalletViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.walletCollectionViewData.count > 0 {
        
            guard let trans = self.walletCollectionViewData[self.selectedWallet].transactions else { return 0 }
            guard let results = trans.results else { return 0 }
            return results.count
        }
        return 0
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        if selectedIndex == indexPath.row {
            
            return tableViewCellHeightOpen
        }
        return tableViewCellHeightClosed
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        
        if let trans = self.walletCollectionViewData[self.selectedWallet].transactions {
            
            if let entries = trans.results {
            
                (cell as! TransactionTableViewCell).configure(data:entries[indexPath.row])
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.row {
            
            self.selectedIndex = nil
        } else {
            
            self.selectedIndex = indexPath.row
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension WalletViewController  {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCollectionViewCell",
                                                      for: indexPath)
        
        (cell as! WalletCollectionViewCell).config(data: self.walletCollectionViewData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        return self.walletCollectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width -= collectionView.contentInset.left
        cellSize.width -= collectionView.contentInset.right

        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        //if self.walletCardList[indexPath.row].type == .addAccount {
            
        //    NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshAccount"), object: nil)
        //}
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.collectionViewUpdating = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        print("page = \(page)")
        
        self.collectionViewUpdating = false
        self.selectedIndex = nil
        self.selectedWallet = page
        self.tableView.reloadData()
    }
}


