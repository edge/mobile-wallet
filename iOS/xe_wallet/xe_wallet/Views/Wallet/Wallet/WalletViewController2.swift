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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.navigationController?.navigationBar.topItem?.title = "Wallet"
        //self.title = "Wallet"
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletPortfolioTableViewCell", size: 56, data: ""))
        
        let sSize = UIScreen.main.bounds
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletCardsTableViewCell", size: ((sSize.width - 32)/1.58)+28, data: "") )
        
        //self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletManageTableViewCell", size: 28), data: "")
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletButtonsTableViewCell", size: 70, data: ""))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletHeaderTableViewCell", size: 58, data: "Last transaction"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "TransactionTableViewCell", size: 66, data: ""))
        
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletHeaderTableViewCell", size: 58, data: "Markets"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletMarketTableViewCell", size: 96, data: "Ethereum"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletMarketTableViewCell", size: 96, data: "Edge"))
        
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletHeaderTableViewCell", size: 58, data: "More things"))
        self.walletScreenSegments.append(WalletScreenSegment(cellName: "WalletDisclaimerTableViewCell", size: 128, data: ""))
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.refreshControl?.tintColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        
        if WalletDataModelManager.shared.activeWalletAmount() == 0 {
            
            performSegue(withIdentifier: "ShowAddWallet", sender: nil)
        }
        
        self.selectedWalletAddress = WalletDataModelManager.shared.getInitialWalletAddress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        
        self.tableView.reloadData()
    }
    
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...

        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
        
    @IBAction func unwindToWalletView(sender: UIStoryboardSegue) {

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
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletCardsTableViewCell" {
         
            (cell as! WalletCardsTableViewCell).delegate = self
            (cell as! WalletCardsTableViewCell).configure()
        }
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletHeaderTableViewCell" {
         
            (cell as! WalletHeaderTableViewCell).titleLabel.text = self.walletScreenSegments[indexPath.row].data
        }
        
        if self.walletScreenSegments[indexPath.row].cellName == "WalletMarketTableViewCell" {
         
            (cell as! WalletMarketTableViewCell).configure(data: self.walletScreenSegments[indexPath.row].data)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.walletScreenSegments[indexPath.row].cellName == "TransactionTableViewCell" {
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
            
                let contentVC = UIStoryboard(name: "TransactionPage", bundle: nil).instantiateViewController(withIdentifier: "TransactionPageViewController") as! TransactionPageViewController
                self.presentPanModal(contentVC)
            }
        }
        
    }
}

extension WalletViewController2 {
    
    func setSelectedWalletAddress(address: String) {
        
        self.selectedWalletAddress = address
    }
    
    func activateSelectedCard() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        
            let contentVC = UIStoryboard(name: "WalletPage", bundle: nil).instantiateViewController(withIdentifier: "WalletPageViewController") as! WalletPageViewController
            self.presentPanModal(contentVC)
        }
    }
}
