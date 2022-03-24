//
//  WalletViewController2.swift
//  xe_wallet
//
//  Created by Paul Davis on 12/12/2021.
//

import UIKit
import PanModal

class WalletScreenSegment {
    
    var cellName: String = ""
    var size: CGFloat = 64
    var data: String = ""
    
    init(cellName: String, size: CGFloat, data: String) {
        
        self.cellName = cellName
        self.size = size
        self.data = data
    }
}

class WalletViewController2: UITableViewController, WalletCardsTableViewCellDelegate {

    @IBOutlet weak var pageViewController: UIPageControl!
    var walletScreenSegments: [WalletScreenSegment] = []
    
    var selectedWalletAddress = ""
    var portfolioCell: WalletPortfolioTableViewCell? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.separatorColor = .clear
        
        self.buildMainPage()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.refreshControl?.tintColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onForceMainPageRefresh(_:)), name: .forceMainPageRefresh, object: nil)
        
        self.selectedWalletAddress = WalletDataModelManager.shared.getInitialWalletAddress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if WalletDataModelManager.shared.activeWalletAmount() == 0 {
            
            performSegue(withIdentifier: "ShowAddXeStartup", sender: nil)
        }
        self.tableView.reloadData()
    }

    @objc func onForceMainPageRefresh(_ notification: Notification) {
        
        self.selectedWalletAddress = WalletDataModelManager.shared.getInitialWalletAddress()
        self.buildMainPage()
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        
        self.buildMainPage()
    }
        
    func buildMainPage() {
                
        self.walletScreenSegments.removeAll()
        
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletPortfolioTableViewCell", size: 56, data: ""))
        
        let sSize = UIScreen.main.bounds
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletCardsTableViewCell", size: ((sSize.width - 32)/1.58)+28, data: "") )
        
        //self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletManageTableViewCell", size: 28), data: "")
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletButtonsTableViewCell", size: 60, data: ""))
        
        if let latestTrans = WalletDataModelManager.shared.latestTransaction {
        
            self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletHeaderTableViewCell", size: 58, data: "Last Transaction"))
            self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletPageTransactionTableViewCell", size: 56, data: ""))
        }
        
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletHeaderTableViewCell", size: 58, data: "Markets"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletMarketTableViewCell", size: 76, data: "Ethereum"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletMarketTableViewCell", size: 76, data: "Edge"))
        
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletHeaderTableViewCell", size: 58, data: "Other Stuff"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletMenuItemTableViewCell", size: 56, data: "Settings"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletMenuItemTableViewCell", size: 56, data: "Signal"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletMenuItemTableViewCell", size: 56, data: "Earn"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletMenuItemTableViewCell", size: 56, data: "Learn"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletDisclaimerTableViewCell", size: 128, data: ""))
        
        self.tableView.reloadData()
    }
    
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...

        WalletDataModelManager.shared.reloadAllWalletInformation()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
        
    @IBAction func unwindToWalletView(sender: UIStoryboardSegue) {

        //self.selectedWalletAddress = WalletDataModelManager.shared.getInitialWalletAddress()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is AddWalletViewController {
            
            let vc = segue.destination as? AddWalletViewController
            vc?.preventXE = false
            vc?.unwindToExchange = false
        }
    }
    
    @IBAction func addWalletButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ShowAddWallet", sender: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "SendViewController") as! SendViewController
            contentVC.selectedWalletAddress = self.selectedWalletAddress
            self.presentPanModal(contentVC)
        }
    }
    
    @IBAction func receiveButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "Receive", bundle: nil).instantiateViewController(withIdentifier: "ReceiveViewController") as! ReceiveViewController
            contentVC.selectedWalletAddress = self.selectedWalletAddress
            contentVC.deletegate = self
            self.presentPanModal(contentVC)
        }
    }
    
    @IBAction func exchangeButtonPressed(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.walletScreenSegments.count
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return self.walletScreenSegments[indexPath.row].size
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: self.walletScreenSegments[indexPath.row].cellName, for: indexPath)
        cell.selectionStyle = .none
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletPortfolioTableViewCell" {
         
            self.portfolioCell = cell as! WalletPortfolioTableViewCell
            (cell as! WalletPortfolioTableViewCell).configure(address: self.selectedWalletAddress)
        }
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletCardsTableViewCell" {
         
            (cell as! WalletCardsTableViewCell).delegate = self
            (cell as! WalletCardsTableViewCell).configure()
        }
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletPageTransactionTableViewCell" {
         
            if let transaction = WalletDataModelManager.shared.latestTransaction { //} self.lastTransactionTransaction {
            
                if let lastWallet = WalletDataModelManager.shared.latestTransactionWallet {//} self.lastTransactionWallet {
                
                    (cell as! WalletPageTransactionTableViewCell).configure(data: transaction , type: lastWallet.type, address: lastWallet.address)
                }
            }
        }
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletHeaderTableViewCell" {
         
            (cell as! WalletHeaderTableViewCell).titleLabel.text = self.walletScreenSegments[indexPath.row].data
        }
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletMarketTableViewCell" {
         
            (cell as! WalletMarketTableViewCell).configure(data: self.walletScreenSegments[indexPath.row].data)
        }
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletMenuItemTableViewCell" {
         
            (cell as! WalletMenuItemTableViewCell).configure(data: self.walletScreenSegments[indexPath.row].data)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletPageTransactionTableViewCell" {
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
            
                let contentVC = UIStoryboard(name: "TransactionPage", bundle: nil).instantiateViewController(withIdentifier: "TransactionPageViewController") as! TransactionPageViewController
                contentVC.transactionData = WalletDataModelManager.shared.latestTransaction// self.lastTransactionTransaction
                if let wallet = WalletDataModelManager.shared.latestTransactionWallet {// self.lastTransactionWallet {
                
                    contentVC.walletType = wallet.type
                }
                self.presentPanModal(contentVC)
            }
        }
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletMenuItemTableViewCell" {
            
            if self.walletScreenSegments[indexPath.row].data == "Settings" {
    
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.performSegue(withIdentifier: "ShowSettingsViewController", sender: nil)
                })
            } else if self.walletScreenSegments[indexPath.row].data == "Signal" {

                self.tabBarController?.selectedIndex = 2
            } else if self.walletScreenSegments[indexPath.row].data == "Earn" {

                self.tabBarController?.selectedIndex = 3
            } else if self.walletScreenSegments[indexPath.row].data == "Learn" {
                
                self.tabBarController?.selectedIndex = 4
            }
        }
    }
}

extension WalletViewController2: WalletPageViewControllerDelegate {

    func setSelectedWalletAddress(address: String) {
        
        self.selectedWalletAddress = address
        self.portfolioCell?.configure(address: address)
        WalletDataModelManager.shared.selectedWalletAddress = address
        WalletDataModelManager.shared.exchangeRefreshNeeded = true
    }
    
    func activateSelectedCard() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "WalletPage", bundle: nil).instantiateViewController(withIdentifier: "WalletPageViewController") as! WalletPageViewController
            contentVC.selectedWalletAddress = self.selectedWalletAddress
            contentVC.delegate = self
            self.presentPanModal(contentVC)
        }
    }
    
    func exchangeButtonPressed() {
        
        self.tabBarController?.selectedIndex = 1
    }
}

extension WalletViewController2: ReceiveViewControllerDelegate {
    
    func copySelected() {
        
        let centerX = UIScreen.main.bounds.maxX / 2
        let centerY = UIScreen.main.bounds.maxY / 2
        self.view.makeToast("Address copied to clipboard", duration: Constants.toastDisplayTime, point: CGPoint(x: centerX, y: centerY-100), title: nil, image: nil, completion: nil)
    }
}
