//
//  LearnTableViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 01/02/2022.
//

import UIKit

class LearnTableData {
    
    var cellType: String
    var height: CGFloat
    var title: String
    var image: String
    var link: String
    
    init(cellType: String, height: CGFloat, title: String, image: String, link: String) {
        
        self.cellType = cellType
        self.height = height
        self.title = title
        self.image = image
        self.link = link
    }
}

class LearnTableViewController: UITableViewController {
    
    var learnCellArray: [LearnTableData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        NotificationCenter.default.addObserver(self, selector: #selector(forceUpdate(_:)), name: .learnForceUpdate, object: nil)
        
        self.configureViews()
        self.configureArrayData()
    }
    
    @objc func forceUpdate(_ notification: Notification) {
        
        self.configureArrayData()
    }
    
    func configureViews() {
        
        self.tableView.separatorColor = .clear
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func configureArrayData() {
        
        self.learnCellArray = []
        self.learnCellArray.append(LearnTableData(cellType: "LearnHeaderTableViewCell", height: 48, title: "About Edge", image: "", link: ""))
        self.learnCellArray.append(LearnTableData(cellType: "LearnMenuItemTableViewCell", height: 56, title: "Edge Network Website", image: "edge", link: "https://edge.network/"))
        if AppDataModelManager.shared.testModeStatus() == .test {
            
            self.learnCellArray.append(LearnTableData(cellType: "LearnMenuItemTableViewCell", height: 56, title: "XE Explorer", image: "xe", link: "https://test.network/"))
        } else {
            
            self.learnCellArray.append(LearnTableData(cellType: "LearnMenuItemTableViewCell", height: 56, title: "XE Explorer", image: "xe", link: "https://xe.network/"))
        }
        self.learnCellArray.append(LearnTableData(cellType: "LearnMenuItemTableViewCell", height: 56, title: "Community Wiki", image: "wiki", link: "https://wiki.edge.network/"))
        self.learnCellArray.append(LearnTableData(cellType: "LearnHeaderTableViewCell", height: 58, title: "Help & Support", image: "", link: ""))
        self.learnCellArray.append(LearnTableData(cellType: "LearnMenuItemTableViewCell", height: 56, title: "FAQ", image: "faq", link: "https://wiki.edge.network/support/faq"))
        self.learnCellArray.append(LearnTableData(cellType: "LearnMenuItemTableViewCell", height: 56, title: "Email Support", image: "email", link: "mailto:support@edge.network"))
        self.learnCellArray.append(LearnTableData(cellType: "LearnMenuItemTableViewCell", height: 56, title: "Discord", image: "discord", link: "https://discord.gg/edge-network"))
        self.learnCellArray.append(LearnTableData(cellType: "LearnDisclaimerTableViewCell", height: 144, title: "", image: "", link: ""))
        self.tableView.reloadData()
    }
}

extension LearnTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.learnCellArray.count
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return self.learnCellArray[indexPath.row].height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: self.learnCellArray[indexPath.row].cellType, for: indexPath)
        cell.selectionStyle = .none
        
        if self.learnCellArray[indexPath.row].cellType ==  "LearnHeaderTableViewCell" {
            
            (cell as? LearnHeaderTableViewCell)?.configure(data: self.learnCellArray[indexPath.row])
        } else if self.learnCellArray[indexPath.row].cellType ==  "LearnMenuItemTableViewCell" {
            
            (cell as? LearnMenuItemTableViewCell)?.configure(data: self.learnCellArray[indexPath.row])
        } else if self.learnCellArray[indexPath.row].cellType ==  "LearnDisclaimerTableViewCell" {
            
            (cell as? LearnDisclaimerTableViewCell)?.configure()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let link = self.learnCellArray[indexPath.row].link
        if link != "" {
            
            if let url = URL(string: link) {
                
                UIApplication.shared.open(url)
            }
        }
    }
}


