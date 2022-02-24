//
//  SignalViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 30/01/2022.
//

import UIKit
import SDWebImage

class SignalTableViewController: UITableViewController, XMLParserDelegate {

    var myFeed : NSArray = []
    var feedImgs: [AnyObject] = []
    var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorColor = .clear
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.refreshControl?.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.tableView.contentOffset.y == 0 {
            
            self.tableView.contentOffset = CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height ?? 0));
            self.refreshControl?.beginRefreshing()
        }
        self.refresh(sender: self)
    }

    @objc func refresh(sender:AnyObject)
    {

        self.loadData()
    }

    func loadData() {

        url = URL(string: "https://edge.network/en/rss/")!
        let myParser : XmlParserManager = XmlParserManager().initWithURL(url) as! XmlParserManager
        feedImgs = myParser.img as [AnyObject]
        myFeed = myParser.feeds
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "OpenPage" {
            
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let selectedFURL: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "link") as! String

            // Instance of our feedpageviewcontrolelr.
            let fiwvc: FeedItemWebViewController = segue.destination as! FeedItemWebViewController
            fiwvc.selectedFeedURL = selectedFURL as String
            
            let selectedTitle: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "title") as! String
            fiwvc.selectedTitle = selectedTitle as String
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.myFeed.count == 0 {
            
            self.tableView.setEmptyMessage("Loading")
            return 0 }
        
        self.tableView.restore()
        return self.myFeed.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return self.view.frame.width * 0.62802
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignalTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        
        if let data = self.myFeed.object(at: indexPath.row) as AnyObject? {
            
            if let imageStr = (data.object(forKey: "image") as? String)?.trim() {
                
                (cell as! SignalTableViewCell).mainImage.sd_setImage(with: URL(string: imageStr), placeholderImage: UIImage(named: "defaultSignalImage"))
            } else {
                
                (cell as! SignalTableViewCell).mainImage.image = UIImage(named:"defaultSignalImage")
            }
            
            if let title = (data.object(forKey: "title") as? String)?.trim() {
                
                (cell as! SignalTableViewCell).titleLabel.text = title
            }

            if let pubDate = (data.object(forKey: "pubDate") as? String)?.trim() {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                let date1 = formatter.date(from: pubDate) ?? Date()
                formatter.dateFormat = "EE, d MMM yyyy HH:mm"

                let dString = formatter.string(from: date1)
                (cell as! SignalTableViewCell).dateLabel.text = "\(dString)"
            }
        }
        return cell
    }

    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{

        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;

        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
}

