//
//  ExchangeViewController2.swift
//  xe_wallet
//
//  Created by Paul Davis on 03/01/2022.
//

import Foundation
import UIKit

class ExchangeViewController2: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    var walletData = [WalletDataModel]()
    var walletData2 = [WalletDataModel]()
    var selectedWallet = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        self.collectionView2.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        self.collectionView2.decelerationRate = UIScrollView.DecelerationRate.fast
        
        let layout = BouncyLayout2(style: .regular)
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        
        let layout2 = BouncyLayout2(style: .regular)
        layout2.scrollDirection = .horizontal
        self.collectionView2.collectionViewLayout = layout2
        
        self.walletData = WalletDataModelManager.shared.getWalletData()
        self.walletData2 = WalletDataModelManager.shared.getWalletData()
        self.collectionView.reloadData()
        self.collectionView2.reloadData()
    }
    
    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExchangeWalletCollectionViewCell",
                                                      for: indexPath)
        
        (cell as! ExchangeWalletCollectionViewCell).config(data: self.walletData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        if collectionView.tag == 0 {
            
            return self.walletData.count
        }
        
        return self.walletData2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width -= collectionView.contentInset.left
        cellSize.width -= collectionView.contentInset.right

        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        //if self.walletCardList[indexPath.row].type == .addAccount {
            
        //    NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshAccount"), object: nil)
        //}
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.tag == 0 {
            
            let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
            let index = scrollView.contentOffset.x / witdh
            let roundedIndex = round(index)
            let idx = Int(roundedIndex)
            
            if self.walletData.count > 0 {
                
                if idx >= 0 && idx < self.walletData.count {
                    
                    self.selectedWallet =  self.walletData[idx].address
                }
            }
        }
    }
}
