//
//  WalletPageViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/01/2022.
//

import UIKit
import PanModal

protocol WalletPageViewControllerDelegate {

    func exchangeButtonPressed()
}

class WalletPageViewController: BaseViewController, UITableViewDelegate,  UITableViewDataSource {

    
    @IBOutlet weak var walletIconImage: UIImageView!
    @IBOutlet weak var walletAddressLabel: UILabel!
    @IBOutlet weak var walletTotalValue: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopGradientView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var delegate: WalletPageViewControllerDelegate? = nil
    
    var assetsArray: [WalletPageAsset] = []
    var transactionsArray: [TransactionDataModel] = []
    
    var walletData: WalletDataModel? = nil
    var selectedWalletAddress = ""
    
    var ethereumExchangeRate = 0.0
    var edgeExchangeRate = 0.0
    var totalValue = 0.0
    
    var timer: Timer?
    var walletType: WalletType = .ethereum
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.configureViews()
        self.configureViewsData()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: Constants.WalletPageUpdateTimer, repeats: true) { timer in
            
            self.configureViewsData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.timer != nil {
            
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    func configureViews() {
        
        /// UISegmentedControl
        ///
        self.segmentedControl.backgroundColor = UIColor.black
        self.segmentedControl.selectedSegmentTintColor = UIColor(named: "PinEntryBoxBackground")
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "Inter-Medium", size: 14.0)!,
            NSAttributedString.Key.foregroundColor: UIColor(named:"FontSecondary")
        ]
        self.segmentedControl.setTitleTextAttributes(defaultAttributes, for: .normal)
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "Inter-Medium", size: 14.0)!,
            NSAttributedString.Key.foregroundColor: UIColor(named:"FontMain")
        ]
        self.segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        /// UITableView
        ///
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0);
        self.tableView.separatorColor = .clear
        
        /// TableView top gradient view
        ///
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0, 0.8, 1]
        gradientLayer.frame = self.tableViewTopGradientView.bounds
        self.tableViewTopGradientView.layer.mask = gradientLayer
    }
    
    func configureViewsData() {
        
        self.walletData = WalletDataModelManager.shared.getSelectedWalletData(address: self.selectedWalletAddress)

        if let status = self.walletData?.status {
        
            if walletData?.type == .xe {
            
                self.walletTotalValue.text = "\(CryptoHelpers.generateCryptoValueString(value: Double(status.balance))) XE"
            } else {
            
                let edgeBalance = status.getTokenBalance(type: .edge)
                self.walletTotalValue.text = "\(CryptoHelpers.generateCryptoValueString(value: Double(edgeBalance))) EDGE"
            }
        }
        
        self.refreshExchangeRates()
        
        self.transactionsArray.removeAll()
        if let wData = self.walletData {

            self.walletType = wData.type
            if let trans = wData.transactions {
                
                self.transactionsArray = trans.sorted(by: {$0.timestamp > $1.timestamp})
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        self.tableView.reloadData()
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
        
        self.delegate?.exchangeButtonPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }

    func refreshExchangeRates() {
        
        self.assetsArray.removeAll()
        self.totalValue = 0.0
        self.edgeExchangeRate = 0.0
        if let exRates = XEExchangeRatesManager.shared.getRates() {
            
            self.edgeExchangeRate = exRates.rate
        }

        self.ethereumExchangeRate = Double(truncating: EtherExchangeRatesManager.shared.getRateValue())
        
        
        if let wallet = self.walletData {
        
            self.walletIconImage.image = UIImage(named:wallet.type.rawValue)
            self.walletAddressLabel.text = self.selectedWalletAddress

            if wallet.type == .xe {
                
                let amount = wallet.status?.balance ?? 0
                self.assetsArray.append(WalletPageAsset(walletType:.xe, tokenType: nil, amount:amount, value:amount * self.edgeExchangeRate))
                self.totalValue += amount * self.edgeExchangeRate
            } else {
                
                let amount = wallet.status?.balance ?? 0
                self.assetsArray.append(WalletPageAsset(walletType:.ethereum, tokenType: nil, amount:amount, value:amount * self.ethereumExchangeRate))
                self.totalValue += amount * self.ethereumExchangeRate
                
                if let erc20 = wallet.status?.erc20Tokens {
                    
                    for erc in erc20 {
                        
                        self.assetsArray.append(WalletPageAsset(walletType:.ethereum, tokenType:erc.type, amount:erc.balance, value:erc.balance * self.edgeExchangeRate))
                        self.totalValue += erc.balance * self.edgeExchangeRate
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
}

extension WalletPageViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.segmentedControl.selectedSegmentIndex == 1 {
            
            self.tableView.restore()
            return self.assetsArray.count
        }
        
        if self.transactionsArray.count == 0 {
            
            self.tableView.setEmptyMessage("No Transactions")
            return 0 }
        self.tableView.restore()
        return self.transactionsArray.count
    }
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cellName = "WalletPageAssetTableViewCell"
        if self.segmentedControl.selectedSegmentIndex == 0 {
            
            cellName = "WalletPageTransactionTableViewCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        cell.selectionStyle = .none
        
        if self.segmentedControl.selectedSegmentIndex == 1 {
            
            (cell as! WalletPageAssetTableViewCell).configure(data: self.assetsArray[indexPath.row])
        } else {
            
            (cell as! WalletPageTransactionTableViewCell).configure(data: self.transactionsArray[indexPath.row], type: self.walletType, address: selectedWalletAddress)
        }
        //self.walletTotalValue.text = String(format:"$%.2f", self.totalValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                let contentVC = UIStoryboard(name: "TransactionPage", bundle: nil).instantiateViewController(withIdentifier: "TransactionPageViewController") as! TransactionPageViewController
                contentVC.transactionData = self.transactionsArray[indexPath.row]
                contentVC.walletType = self.walletType
                contentVC.walletAddress = self.selectedWalletAddress
                self.presentPanModal(contentVC)
            }
        }
    }
}

extension WalletPageViewController: ReceiveViewControllerDelegate {
    
    func copySelected() {
        
        let centerX = UIScreen.main.bounds.maxX / 2
        let centerY = UIScreen.main.bounds.maxY / 2
        self.view.makeToast("Address copied to clipboard", duration: Constants.toastDisplayTime, point: CGPoint(x: centerX, y: centerY-90), title: nil, image: nil, completion: nil)
    }
}


extension WalletPageViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .maxHeightWithTopInset(40) }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}

