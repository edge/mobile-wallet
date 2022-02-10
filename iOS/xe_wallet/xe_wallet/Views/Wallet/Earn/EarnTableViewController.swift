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
    var data11: String
    var data12: String
    var data21: String
    var data22: String
    
    init(type: WalletType, header: String, body: String, data11: String, data12: String, data21: String, data22: String) {
        
        self.type = type
        self.header = header
        self.body = body
        self.data11 = data11
        self.data12 = data12
        self.data21 = data21
        self.data22 = data22
    }
}

class EarnTableViewController: UITableViewController {
    
    var earnSegments: [EarnSegmentData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.configureArrayData()
        self.tableView.separatorColor = .clear
    }
    
    func configureArrayData() {
        
        self.earnSegments.append(EarnSegmentData(type: .xe, header: "XE Staking", body: "Start earning rewards on your XE today.  Simplified staking with no minimum requirements and instant activation.", data11: "Total staked", data12: "1,213,134", data21: "Current APY", data22: "4.2%"))
        self.earnSegments.append(EarnSegmentData(type: .edge, header: "Run a Node", body: "Contribute your spare capacity to the Edge Network and earn passive income", data11: "Nodes online", data12: "12,839", data21: "Current APY", data22: "12.65%"))
        self.earnSegments.append(EarnSegmentData(type: .ethereum, header: "Eth Staking", body: "Stake against Ethereum 2.0 nodes running in the Edge Network and earn rewards.", data11: "Total staked", data12: "96", data21: "Current APY", data22: "4.45%"))
    }
}

extension EarnTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.earnSegments.count
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 256
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

