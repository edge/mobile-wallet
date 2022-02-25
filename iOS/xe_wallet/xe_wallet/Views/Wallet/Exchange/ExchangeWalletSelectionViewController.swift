//
//  ExchangeWalletSelectionViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 16/02/2022.
//

import UIKit
import PanModal

enum ExchangeWalletSelectionType {
    
    case wallet
    case token
}

protocol ExchangeWalletSelectionViewControllerDelegate {

    func setSelectedData(tag: Int, data: String)
}

class ExchangeWalletSelectionViewController: BaseViewController, UITableViewDelegate,  UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var overlayGradientView: UIView!
    @IBOutlet weak var overlayGradientViewBottom: UIView!
    
    var walletData: [WalletDataModel] = []
    var tokenData: [ExchangeTokenSelectionDataModel] = []
    var titleString = ""
    var type: ExchangeWalletSelectionType = .wallet
    var selectedWalletIndex = 0
    var tag = 0
    
    var delegate:ExchangeWalletSelectionViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.configureViews()
        self.configureTableViewArray()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func configureViews() {
        
        self.titleLabel.text = self.titleString
        
        /// UITableView
        ///
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0);
        self.tableView.separatorColor = .clear
        
        /// TableView top gradient view
        ///
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0, 0.8, 1]
        gradientLayer.frame = self.overlayGradientView.bounds
        self.overlayGradientView.layer.mask = gradientLayer
        
        let gradientLayerBottom = CAGradientLayer()
        gradientLayerBottom.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayerBottom.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayerBottom.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
        gradientLayerBottom.locations = [0, 0.8, 1]
        gradientLayerBottom.frame = self.overlayGradientViewBottom.bounds
        self.overlayGradientViewBottom.layer.mask = gradientLayerBottom
    }
    
    func configureTableViewArray() {
        
        if self.type == .wallet {
        
            
        } else if self.type == .token {
            
            let wallet = self.walletData[self.selectedWalletIndex]
            self.tokenData.removeAll()
            //self.tokenData.append(ExchangeTokenSelectionDataModel(type:.ethereum, address: "Ethereum", abv: "$ETH", balance:wallet.status?.balance ?? 0, value: wallet.status?.balance ?? 0))
            self.tokenData.append(ExchangeTokenSelectionDataModel(type:.edge, address: "Edge", abv: "$EDGE", balance:wallet.status?.edgeBalance ?? 0, value: wallet.status?.edgeBalance ?? 0))
        }
        self.tableView.reloadData()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
}

extension ExchangeWalletSelectionViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.type == .wallet {

            return self.walletData.count
        }
        return self.tokenData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellName = "ExchangeWalletSelectionTableViewCell"
        if self.type == .token {
            
            cellName = "ExchangeTokenSelectionTableViewCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        cell.selectionStyle = .none
        
        if self.type == .wallet {
        
            let wallet = self.walletData[indexPath.row]
            (cell as! ExchangeWalletSelectionTableViewCell).tokenImage.image = UIImage(named:wallet.type.rawValue)
            (cell as! ExchangeWalletSelectionTableViewCell).addressLabel.text = wallet.address
        } else {
            
            let token = self.tokenData[indexPath.row]
            (cell as! ExchangeTokenSelectionTableViewCell).tokenImage.image = UIImage(named:token.type.rawValue)
            (cell as! ExchangeTokenSelectionTableViewCell).addressLabel.text = token.address
            (cell as! ExchangeTokenSelectionTableViewCell).abvLabel.text = token.abv
            (cell as! ExchangeTokenSelectionTableViewCell).amountLabel.text = CryptoHelpers.generateCryptoValueString(value: token.balance ?? 0)
            
            let etherrate = Double(EtherExchangeRatesManager.shared.getRateValue())
            let edgerate = XEExchangeRatesManager.shared.getRates()?.rate
            let value = token.value
            if token.type == .edge {
            
                (cell as! ExchangeTokenSelectionTableViewCell).valueLabel.text = "$\(StringHelpers.generateValueString(value: Double(truncating: value * (edgerate ?? 0) as! NSNumber)))"
            } else {
            
                (cell as! ExchangeTokenSelectionTableViewCell).valueLabel.text = "$\(StringHelpers.generateValueString(value: Double(truncating: value * (etherrate ?? 0) as! NSNumber)))"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.type == .wallet {
        
            self.delegate?.setSelectedData(tag: self.tag, data: self.walletData[indexPath.row].address)
        } else {
            
            self.delegate?.setSelectedData(tag: self.tag, data: self.tokenData[indexPath.row].address)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension ExchangeWalletSelectionViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .contentHeight(281)  }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}

