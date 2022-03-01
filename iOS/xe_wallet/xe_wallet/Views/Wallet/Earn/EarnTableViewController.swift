//
//  LearnTableViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 28/01/2022.
//

import UIKit

class EarnSegmentData {
    
    var type: WalletType = .ethereum
    var header: String
    var body: String
    var data: [String]

    
    init(type: WalletType, header: String, body: String, data: [String]) {
        
        self.type = type
        self.header = header
        self.body = body
        self.data = data
    }
}

class EarnTableViewController: UITableViewController {
    
    var earnSegments: [EarnSegmentData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.configureArrayData()
        self.tableView.separatorColor = .clear
    }
    
    func configureArrayData() {
        
        let stakedData = XEStakedDataManagerManager.shared.getStakeData()
        var stakedCount = "0"
        if let count = stakedData?.count {
            
            stakedCount = "\(count)"
        }
        var stakedAmount = "0"
        if let amount = stakedData?.stakedAmount {
            
            stakedAmount = "\(CryptoHelpers.generateCryptoValueStringNoDecimal(value: amount/1000000 ?? 0))"
        }
        
        self.earnSegments.append(EarnSegmentData(type: .xe, header: "XE Staking", body: "Start earning rewards on your XE today.  Simplified staking with no minimum requirements and instant activation.", data: ["Stakes", stakedCount, "Staked XE", stakedAmount]))
        
//        Stargates / Gateways / Hosts
        self.earnSegments.append(EarnSegmentData(type: .edge, header: "Run a Node", body: "Contribute your spare capacity to the Edge Network and earn passive income.", data: [])) //["Stargates", "TBC", "Gateways", "TBC", "Hosts", "TBC"]))
        
        
        self.earnSegments.append(EarnSegmentData(type: .ethereum, header: "Eth Staking", body: "Stake against Ethereum 2.0 nodes running in the Edge Network and earn rewards.", data: []))//["Total staked", "Coming Soon", "Current APY", "Coming Soon"]))
    }
}

extension EarnTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.earnSegments.count
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 240
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "EarnTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        
        (cell as! EarnTableViewCell).configure(data: self.earnSegments[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

