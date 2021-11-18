//
//  ReceiveViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 14/10/2021.
//

import UIKit
import CoreImage.CIFilterBuiltins
import CoreImage.CIFilterConstructor

class ReceiveViewController: BaseViewController, CustomTitleBarDelegate {
        
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var creditCardImage: UIImageView!
    
    @IBOutlet weak var QRImageView: UIImageView!
    
    @IBOutlet weak var customTitleBarView: CustomTitleBar!
            
    var selectedWalletAddress = ""
    var walletData: WalletDataModel? = nil
    var cardImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.backgroundView.alpha = 0.0
        
        self.creditCardImage.image = self.cardImage
        
        self.QRImageView.layer.magnificationFilter = CALayerContentsFilter.nearest
        
        if let qrImage = generateQrCode2(self.selectedWalletAddress) {
            
            self.QRImageView.image = UIImage(ciImage: qrImage)
            let smallLogo = UIImage(named: "qrlogo")
            smallLogo?.addToCenter(of: self.QRImageView)
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        self.customTitleBarView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.cardViewTopConstraint.constant = Constants.cardViewTopConstraintEnd
        self.cardViewRightConstraint.constant = Constants.cardViewSideConstraintEnd
        self.cardViewLeftConstraint.constant = Constants.cardViewSideConstraintEnd
        UIView.animate(withDuration: Constants.screenFadeTransitionSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

        })
    }
        
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeWindow()
        }
    }
    
    func closeWindow() {
        
        self.cardViewTopConstraint.constant = Constants.cardViewTopConstraintStart
        self.cardViewRightConstraint.constant = Constants.cardViewSideConstraintStart
        self.cardViewLeftConstraint.constant = Constants.cardViewSideConstraintStart
        UIView.animate(withDuration: Constants.screenFadeTransitionSpeed, delay: 0, options: .curveEaseOut, animations: {

            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { finished in

            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func generateQrCode2(_ content: String)  -> CIImage? {
        
        let data = content.data(using: String.Encoding.ascii, allowLossyConversion: false)

        let filter = CIFilter(name: "CIQRCodeGenerator")

        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")

        if let qrCodeImage = (filter?.outputImage){
            
            return qrCodeImage
        }
        return nil
    }
    
}

extension ReceiveViewController {
    
    func letButtonPressed() {
    }
    
    func rightButtonPressed() {

        self.closeWindow()
    }
}
