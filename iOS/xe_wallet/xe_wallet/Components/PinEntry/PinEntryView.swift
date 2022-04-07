//
//  PinEntry.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit

@IBDesignable class PinEntryViewWrapper : NibWrapperView<PinEntryView> { }

@IBDesignable class PinEntryView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var pinTickBoxes:[UIView]!
    
    func setBoxesUsed(amt: Int) {
        
        for index in 0...5 {
            
            if  index < amt {
                
                pinTickBoxes[index].isHidden = false
            } else {
                
                pinTickBoxes[index].isHidden = true
            }
        }
    }
}
