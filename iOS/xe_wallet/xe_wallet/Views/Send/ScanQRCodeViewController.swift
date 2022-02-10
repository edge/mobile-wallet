//
//  ScanQRCodeViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 26/01/2022.
//

import UIKit
import AVFoundation
import MercariQRScanner

protocol ScanQRCodeViewControllerDelegate {

    func setScannedText(text: String)
}

class ScanQRCodeViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
        
    @IBOutlet weak var closeButtonView: UIView!
    @IBOutlet weak var scanQRCodeLabel: UILabel!
    
    var delegate: ScanQRCodeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let qrScannerView = QRScannerView(frame: view.bounds)
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self)
        qrScannerView.startRunning()
        
        /// add the close button window and title text over main view
        
        view.addSubview(self.closeButtonView)
        view.addSubview(self.scanQRCodeLabel)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        dismiss(animated: true)
    }
}

extension ScanQRCodeViewController: QRScannerViewDelegate {
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        
        self.delegate?.setScannedText(text: code)
        print(code)
        dismiss(animated: true)
    }
}
