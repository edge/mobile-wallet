//
//  DepositViewController.swift
//  xe_wallet
//
//  Created by Paul Davis on 06/11/2021.
//

import UIKit
import DropDown

class ExchangeDepositViewController: BaseViewController, KillViewDelegate, CustomTitleBarDelegate, UITextFieldDelegate {


    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var creditCardImage: UIImageView!

    @IBOutlet weak var customTitleBarView: CustomTitleBar!
    @IBOutlet weak var toButtonAddressLabel: UILabel!
    @IBOutlet weak var toButtonAmountLabel: UILabel!
    
    @IBOutlet weak var toButtonDropDown: UIButton!
    @IBOutlet weak var toButtonImage: UIImageView!
    
    @IBOutlet weak var reviewButtonView: UIView!
    @IBOutlet weak var reviewButtonText: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBAction func chooseToWallet(_ sender: AnyObject) {
        
        toDropDown.show()
    }
    
    var walletData: WalletDataModel? = nil
    var toAddress = ""
    var cardImage: UIImage? = nil
    
    var delegate: KillViewDelegate?
    
    let toDropDown = DropDown()
    var isReviewActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = .clear
        self.creditCardImage.image = self.cardImage
        self.backgroundView.alpha = 0.0
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.amountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.customTitleBarView.delegate = self
        
        self.setupDropDowns()
        self.configureReviewButton()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.toDropDown.width = self.view.frame.width - 32
    }
    
    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    
    func setupDropDowns() {
        
        self.toDropDown.anchorView = self.toButtonDropDown
        self.toDropDown.bottomOffset = CGPoint(x: 0, y: self.toButtonDropDown.bounds.height)
        
        let wallets = WalletDataModelManager.shared.getExchangeOptions(type: .ethereum)
        
        self.toDropDown.dataSource = []
        var cellImages: [String] = []
        var cellAmounts: [String] = []
        
        for wallet in wallets {
            
            self.toDropDown.dataSource.append(wallet.address)
            cellImages.append(wallet.type.rawValue)
            cellAmounts.append("\(String(format: "%.6f", Double(wallet.status?.balance ?? 0)/1000000)) \(wallet.type.getDisplayLabel())")
        }
        
        self.toButtonAddressLabel.text = self.toDropDown.dataSource[0]
        self.toButtonAmountLabel.text = cellAmounts[0]
        self.toButtonImage.image = UIImage(named:cellImages[0])
        self.toAddress = self.toDropDown.dataSource[0]
        
        self.toDropDown.selectionAction = { [weak self] (index, item) in
            
            self?.toButtonAddressLabel.text = self?.toDropDown.dataSource[index]
            self?.toButtonAmountLabel.text = cellAmounts[index]
            self?.toButtonImage.image = UIImage(named:cellImages[index])
            self?.toAddress = self?.toDropDown.dataSource[index] ?? ""
        }
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 56
        appearance.backgroundColor = UIColor(named:"PinEntryBoxBackground")
        appearance.selectionBackgroundColor = UIColor.clear
        appearance.textColor = UIColor(named:"FontSecondary")!
        appearance.textFont = UIFont(name: "Inter-Medium", size: 16)!
        appearance.selectedTextColor = UIColor(named:"FontMain")!
        
        self.toDropDown.cellNib = UINib(nibName: "DropDownSelection", bundle: nil)
        self.toDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            guard let cell = cell as? DropDownSelection else { return }
            
            cell.cellImage.image = UIImage(named:cellImages[index])
            cell.balanceLabel.text = cellAmounts[index]
        }
        
        self.toDropDown.selectRow(at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowExchangeDepositConfirmViewController" {
            
            let controller = segue.destination as! ExchangeDepositConfirmViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.delegate = self
            controller.walletData = self.walletData
            controller.toAddress = ""
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        if gesture.direction == .down {

            self.closeWindow()
        }
    }
    
    @IBAction func depositButtonPressed(_ sender: Any) {
        
        if self.isReviewActive {
        
            performSegue(withIdentifier: "ShowExchangeDepositConfirmViewController", sender: nil)
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
            self.delegate?.killView()
        })
    }
    
    func configureReviewButton() {
        
        if self.isReviewActive {
            
            self.reviewButtonView.backgroundColor = UIColor(named:"ButtonGreen")
            self.reviewButtonText.textColor = UIColor(named: "FontMain")
        } else {
            
            self.reviewButtonView.backgroundColor = UIColor(named:"PinEntryBoxBackground")
            self.reviewButtonText.textColor = UIColor(named: "ButtonTextInactive")
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        var shouldBeActive = false
        
        guard let amountText = self.amountTextField.text else { return }
        
        if amountText != "" {
        
            guard let amountVal = Double(amountText) else { return }
            guard let wallet = self.walletData else { return }
            guard let status = wallet.status else { return }
            
            if amountText != "" {
                
                let walletAmount = status.balance
                
                if amountVal >= wallet.type.getMinSendValue() && amountVal <= Double(walletAmount)/1000000 {
                    
                    shouldBeActive = true
                }
            } else {
                
                shouldBeActive = false
            }
        }
                
        if self.isReviewActive != shouldBeActive {
            
            self.isReviewActive = shouldBeActive
            self.configureReviewButton()
        }
    }
}

extension ExchangeDepositViewController {
    
    func viewNeedsToShow() {
    
        self.backgroundView.alpha = 1.0
    }
    
    func killView() {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func viewNeedsToHide() {
        
        self.view.alpha = 0.0
    }
}

extension ExchangeDepositViewController {
    
    func letButtonPressed() {
    }
    
    func rightButtonPressed() {

        self.closeWindow()
    }
}

