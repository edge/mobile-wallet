//
//  LearnTableViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 28/01/2022.
//

import UIKit

class LearnSegmentData {
    
    var type: WalletType = .ethereum
    
    init(type: WalletType) {
        
        self.type = type
    }
}

class LearnTableViewController: UITableViewController {
    
    var learnSegments: [LearnSegmentData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.configureArrayData()
    }
    
    func configureArrayData() {
        
        self.learnSegments.append(LearnSegmentData(type: .xe))
        self.learnSegments.append(LearnSegmentData(type: .edge))
        self.learnSegments.append(LearnSegmentData(type: .ethereum))
    }
}

extension LearnTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.learnSegments.count
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 256
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "LearnTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        
        (cell as! LearnTableViewCell).configure()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

