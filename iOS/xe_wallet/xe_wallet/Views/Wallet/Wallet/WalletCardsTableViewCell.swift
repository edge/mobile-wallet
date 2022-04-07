//
//  WalletCardsTableViewCell.swift
//  xe_wallet
//
//  Created by Paul Davis on 15/12/2021.
//

import UIKit
import BouncyLayout

protocol WalletCardsTableViewCellDelegate {

    func setSelectedWalletAddress(address: String)
    func activateSelectedCard()
}

class WalletCardsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WalletCardCollectionViewCellDelegate {
            
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var walletData = [WalletDataModel]()
    var delegate: WalletCardsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        let layout = BouncyLayout2(style: .regular)
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        
    }
    
    func configure() {
    
        self.walletData = WalletDataModelManager.shared.getWalletData()
        
        /*if self.walletData.count > 0 {
            
            WalletDataModelManager.shared.setSelectedWalletAddress(address: self.walletData[0].address)
        }*/
        
        self.collectionView.reloadData()
        self.pageController.numberOfPages = self.walletData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCardCollectionViewCell",
                                                      for: indexPath)
        
        (cell as! WalletCardCollectionViewCell).config(data: self.walletData[indexPath.row])
        (cell as! WalletCardCollectionViewCell).delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        //self.delegate?.collectionViewUpdateAmount(amount: self.walletData.count)
        return self.walletData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width -= collectionView.contentInset.left
        cellSize.width -= collectionView.contentInset.right

        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        //self.delegate?.activateSelectedCard()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        let idx = Int(roundedIndex)
        self.pageController.currentPage = idx
        
        if self.walletData.count > 0 {
            
            if idx >= 0 && idx < self.walletData.count {
                
                self.delegate?.setSelectedWalletAddress(address: self.walletData[idx].address)
                //WalletDataModelManager.shared.setSelectedWalletAddress(address: self.walletData[idx].address)
            }
        }
    }
    
    @IBAction func pageControllerPressed(_ sender: UIPageControl) {
        
        let scrollIndex: NSIndexPath = NSIndexPath(item: sender.currentPage, section: 0)
        DispatchQueue.main.async {
        
            self.collectionView.scrollToItem(at: scrollIndex as IndexPath, at: [], animated: true)
        }
    }
}

extension WalletCardsTableViewCell {
    
    func selectedCard() {
        
        self.delegate?.activateSelectedCard()
    }
}
