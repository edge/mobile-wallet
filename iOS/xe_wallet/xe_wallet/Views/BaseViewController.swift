//
//  BaseViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 04/11/2021.
//

import UIKit

protocol KillViewDelegate: AnyObject {
    
    func killView()
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // change status bar color
        //var navigationBarAppearace = UINavigationBar.appearance()
        //navigationBarAppearace.tintColor = .red
        //navigationBarAppearace.barTintColor = .red
        
        //self.navigationController?.navigationBar.barTintColor = .red
        //self.navigationController?.navigationBar.tintColor = .red
        

        var statusColour = UIColor(named:"BackgroundMain")
        if AppDataModelManager.shared.testModeStatus() {
            
           statusColour = UIColor(named:"ButtonGreen")
        }
        if #available(iOS 13, *)
        {
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = statusColour
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
           // ADD THE STATUS BAR AND SET A CUSTOM COLOR
           let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
           if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
               statusBar.backgroundColor = statusColour
           }
           UIApplication.shared.statusBarStyle = .lightContent
        }
    }
}
