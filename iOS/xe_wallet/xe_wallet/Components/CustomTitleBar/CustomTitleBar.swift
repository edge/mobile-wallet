//
//  CustomTitleBar.swift
//  xe_wallet
//
//  Created by Paul Davis on 17/11/2021.
//

import UIKit

@objc public protocol CustomTitleBarDelegate: AnyObject {
    
    func letButtonPressed()
    func rightButtonPressed()
}

@IBDesignable class CustomTitleBar: UIView {
        
    var delegate:CustomTitleBarDelegate?
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var leftButtonView: UIView!
    @IBInspectable var leftButton:Bool = true { didSet {
        
        self.leftButtonView.isHidden = !leftButton
    }}
    
    @IBOutlet weak var rightButtonView: UIView!
    @IBInspectable var rightButton:Bool = true { didSet {

        self.rightButtonView.isHidden = !rightButton
    }}
    
    @IBOutlet weak var leftImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rightImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageRightConstraint: NSLayoutConstraint!
        
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(frame: CGRect, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
        Bundle.main.loadNibNamed("CustomTitleBar", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        self.leftImageTopConstraint.constant = height + 15
        self.leftImageLeftConstraint.constant = UIScreen.main.bounds.width * 0.06
        
        self.rightImageTopConstraint.constant = height + 15
        self.rightImageRightConstraint.constant = UIScreen.main.bounds.width * 0.06
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        
        self.delegate?.letButtonPressed()
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        
        self.delegate?.rightButtonPressed()
    }
}

