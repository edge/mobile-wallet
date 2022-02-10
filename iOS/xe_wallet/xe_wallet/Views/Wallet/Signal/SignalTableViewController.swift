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
        
        //tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 140
        //tableView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorColor = .clear

        loadData()
    }

    @IBAction func refreshFeed(_ sender: Any) {

        loadData()
    }

    func loadData() {
        //url = URL(string: "https://www.nasa.gov/rss/dyn/breaking_news.rss")!
        url = URL(string: "https://edge.network/en/rss/")!
    
        loadRss(url);
    }

    func loadRss(_ data: URL) {

        // XmlParserManager instance/object/variable.
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager

        // Put feed in array.
        feedImgs = myParser.img as [AnyObject]
        myFeed = myParser.feeds
        tableView.reloadData()
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

    // MARK: - Table view data source.
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myFeed.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return self.view.frame.width * 0.62802
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignalTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        
        if let data = self.myFeed.object(at: indexPath.row) as AnyObject? {
            
            if let imageStr = (data.object(forKey: "image") as? String)?.trim() {
                
                //let imageData = NSData(contentsOf:NSURL(fileURLWithPath: imageStr) as URL)
                //let url = NSURL(string:imageStr)
                /*if let idata = NSData(contentsOf:url! as URL) {
                    
                    var img = UIImage(data:idata as Data)
                    img = resizeImage(image: img!, toTheSize: CGSize(width: 366, height: 187))
                    (cell as! SignalTableViewCell).mainImage.image = img
                    
                    

                }*/
                
                //(cell as! SignalTableViewCell).mainImage.image = img
                (cell as! SignalTableViewCell).mainImage.sd_setImage(with: URL(string: imageStr))
            }
            
            if let title = (data.object(forKey: "title") as? String)?.trim() {
                
                (cell as! SignalTableViewCell).titleLabel.text = title
            }
            
            /*if let description = (data.object(forKey: "description") as? String)?.trim() {
                
                (cell as! SignalTableViewCell).descriptionTextView.text = description
            }*/
            
            if let pubDate = (data.object(forKey: "pubDate") as? String)?.trim() {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                let date1 = formatter.date(from: pubDate) ?? Date()
                formatter.dateFormat = "EE, d MMM yyyy HH:mm"

                let dString = formatter.string(from: date1)
                (cell as! SignalTableViewCell).dateLabel.text = "\(dString)"
            }
        }
        
        
        //let cellBGColorView = UIView()
        //let cellImageLayer: CALayer?  = cell.imageView?.layer
        //let url = NSURL(string:feedImgs[indexPath.row] as! String)
        //let data = NSData(contentsOf:url! as URL)
        //var image = UIImage(data:data! as Data)
        
        //image = resizeImage(image: image!, toTheSize: CGSize(width: 70, height: 70))
        
        //cellImageLayer!.cornerRadius = 35
        //cellImageLayer!.masksToBounds = true
        //cellBGColorView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
        
        /*if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(white: 1, alpha: 0)
        } else {
            cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        }*/
        
        //cell.textLabel?.backgroundColor = UIColor.clear
        //cell.detailTextLabel?.backgroundColor = UIColor.clear
        //cell.selectedBackgroundView = cellBGColorView
        //cell.imageView?.image = image
        //cell.textLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String
        //cell.textLabel?.textColor = UIColor.white
        //cell.textLabel?.numberOfLines = 0
        //cell.textLabel?.lineBreakMode = .byWordWrapping
        //cell.detailTextLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "pubDate") as? String
        //cell.detailTextLabel?.textColor = UIColor.white

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

