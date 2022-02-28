//
//  ReceiveViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 14/10/2021.
//

import UIKit
import CoreImage.CIFilterBuiltins
import CoreImage.CIFilterConstructor
import PanModal

protocol ReceiveViewControllerDelegate {

    func copySelected()
}

class ReceiveViewController: BaseViewController {
        
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var QRImageView: UIImageView!
    @IBOutlet weak var walletImageIcon: UIImageView!
    @IBOutlet weak var walletBackgroundImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var imageOuterView: UIView!
    
    var deletegate: ReceiveViewControllerDelegate? = nil
    
    var selectedWalletAddress = ""
    var walletData: WalletDataModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


        self.walletData = WalletDataModelManager.shared.getSelectedWalletData(address: self.selectedWalletAddress)
        if let wallet = self.walletData {
        
            self.walletBackgroundImage.image = UIImage(named:wallet.type.getDataString(dataType: .backgroundImage))
            self.walletImageIcon.image = UIImage(named:wallet.type.rawValue)
            self.addressLabel.text = wallet.address
            self.selectedWalletAddress = wallet.address
        }
        
        self.imageOuterView.isHidden = true
        self.QRImageView.layer.magnificationFilter = CALayerContentsFilter.nearest
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let qrImage = self.generateQrCode2(self.selectedWalletAddress) {
                
                self.QRImageView.image = UIImage(ciImage: qrImage)
                let smallLogo = UIImage(named: "qrlogo")
                smallLogo?.addToCenter(of: self.QRImageView)
                self.imageOuterView.isHidden = false
            }
        }
    }
    
    @IBAction func copyButtonPressed(_ sender: Any) {
        
        UIPasteboard.general.string = self.addressLabel.text

        self.deletegate?.copySelected()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
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

extension ReceiveViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { return nil }
    var allowsExtendedPanScrolling: Bool { return false }
    var anchorModalToLongForm: Bool { return false }
    var cornerRadius: CGFloat { return 12 }
    var longFormHeight: PanModalHeight { return .contentHeight(460) }
    var dragIndicatorBackgroundColor: UIColor { return .clear }
}
