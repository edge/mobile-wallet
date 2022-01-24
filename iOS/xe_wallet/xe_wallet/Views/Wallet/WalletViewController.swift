//
//  WalletViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit
import BouncyLayout

class WalletViewController: BaseViewController, UITableViewDelegate,  UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var exchangeButtonTextLabel: UILabel!
    
    var transactionListViewData = [TransactionRecordDataModel]()
    var walletCollectionViewData = [WalletDataModel]()
    
    var selectedIndex: Int?
    var selectedWallet = 0
    
    let tableViewCellHeightClosed: CGFloat = 66
    let tableViewCellHeightOpen: CGFloat = 234
    
    let walletButtonSegues = ["ShowSendViewController","ShowReceiveViewController","ShowExchangeViewController" ]
    
    var collectionViewUpdating = false
    var timerExchangePrice : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                        
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
                
        self.walletCollectionViewData = WalletDataModelManager.shared.getWalletData()
        self.updateWalletPage()
        
        if WalletDataModelManager.shared.activeWalletAmount() == 0 {
            
            let vc = UIStoryboard.init(name: "AddWallet", bundle: Bundle.main).instantiateViewController(withIdentifier: "InitialWalletViewController") as? InitialWalletViewController
            self.navigationController?.pushViewController(vc!, animated: false)
        }
                
        tableView.allowsSelectionDuringEditing = true
        self.tableView.refreshControl = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        
        let layout = BouncyLayout(style: .regular)
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = AppDataModelManager.shared.getNetworkStatus().rawValue // getNetworkTitleString()
        self.walletCollectionViewData = WalletDataModelManager.shared.getWalletData()
        self.tableView.reloadData()

        /*self.timerExchangePrice = Timer.scheduledTimer(withTimeInterval: Constants.XE_GasPriceUpdateTime, repeats: true) { timer in
            
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        self.collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.timerExchangePrice != nil {
            
            self.timerExchangePrice?.invalidate()
            self.timerExchangePrice = nil
        }
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        
        self.walletCollectionViewData = WalletDataModelManager.shared.getWalletData()
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
            
        if segue.identifier == "ShowAddWalletViewController" {
            
            let controller = segue.destination as! AddWalletViewController
            controller.modalPresentationStyle = .overCurrentContext
        }
        
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
            
            /*if let selectedCardCell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedWallet, section: 0)) as? WalletCollectionViewCell{
                
                controller.cardImage = selectedCardCell.getCardViewImage()
             }*/
            
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
                if self.walletCollectionViewData[self.selectedWallet].type != .xe {
                    
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
    
    func updateWalletPage() {
        
        if self.walletCollectionViewData.count > 0 && self.walletCollectionViewData.count > self.selectedWallet {
            
            let wallet = self.walletCollectionViewData[self.selectedWallet]
            
            if wallet.type == .xe {
                
                self.exchangeButtonTextLabel.text = "Withdraw"
            } else {
                
                self.exchangeButtonTextLabel.text = "Deposit"
            }
        }
    }
    
}

extension WalletViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.walletCollectionViewData.count == 0 { return 0 }
        
        guard let trans = self.walletCollectionViewData[self.selectedWallet].transactions else {
            
            self.tableView.setEmptyMessage("No Transactions")
            return 0 }
        guard let results = trans.results else {
            
            self.tableView.setEmptyMessage("No Transactions")
            return 0 }
        
        if results.count == 0 {
            
            self.tableView.setEmptyMessage("No Transactions")
            return 0
            
        }
        self.tableView.restore()
        return results.count

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
            
                (cell as! TransactionTableViewCell).configure(data:entries[indexPath.row], address: self.walletCollectionViewData[self.selectedWallet].address)
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
    /*
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }*/
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
        
            self.snapToNearestCell(scrollView: scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        self.snapToNearestCell(scrollView: scrollView)
    }
    
    func snapToNearestCell(scrollView: UIScrollView) {
         let middlePoint = Int(scrollView.contentOffset.x + UIScreen.main.bounds.width / 2)
         if let indexPath = self.collectionView.indexPathForItem(at: CGPoint(x: middlePoint, y: 0)) {
              self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
         }
    }
    
    
   /* func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.collectionViewUpdating = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.tag == 1 {
            
            let pageWidth = scrollView.frame.size.width
            let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
            print("page = \(page)")
            
            self.collectionViewUpdating = false
            self.selectedIndex = nil
            self.selectedWallet = page
            self.tableView.reloadData()
            self.updateWalletPage()
        }
    }*/
}


