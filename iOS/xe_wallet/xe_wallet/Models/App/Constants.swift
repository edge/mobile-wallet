//
//  Constants.swift
//  xe_wallet
//
//  Created by Paul Davis on 17/11/2021.
//

import UIKit

class Constants {
    
    /// default storage values
    ///
    static var defaultStorageName = "WalletData9"
    
    /// default button messages
    ///
    static var buttonOkText = "Ok"
    static var buttonCancelText = "Cancel"
    
    /// card screen transitions and positioning
    ///
    static var screenFadeTransitionSpeed = 0.3
    static var cardViewTopConstraintStart: CGFloat = 66
    static var cardViewTopConstraintEnd: CGFloat = 20
    static var cardViewSideConstraintStart: CGFloat = 16
    static var cardViewSideConstraintEnd: CGFloat = 95
    
    /// authentication messages
    ///
    static var confirmIncorrectPinMessageHeader = "Incorrect PIN"
    static var confirmIncorrectPinMessageBody = "The PIN does not match previously entered PIN.  Please try again"
    static var confirmIncorrectPinButtonText = "Retry"
    
    static var enterIncorrectPinMessageHeader = "Incorrect PIN"
    static var enterIncorrectPinMessageBody = "You entered an incorrect PIN.  Please try again"
    static var enterIncorrectPinButtonText = "Retry"
    
    /// settings network change messages
    ///
    static var networkChangeConfirmMessageHeader = "Changing Networks"
    static var networkChangeConfirmMessage = "Are you sure you wish to change to "
    
    /// settings reset messages
    ///
    static var resetAppMessageHeader = "Reset App Data"
    static var resetAppMessageBody = "This will remove all apps data including pins and wallets."

    ///  Delete wallet warning message
    ///
    static var deleteWalletHeader = "Delete Wallet"
    static var deleteWalletBody = "This will remove the wallet from the app."
    
    static var toastDisplayTime = 1.5
    
    /// NETWORK settings
    ///
    static var XE_MainNetStatusUrl = "https://api.xe.network/wallet/"
    static var XE_TestNetStatusUrl = "https://xe1.test.network/wallet/"
    
    /// XE transactions endpoint
    ///
    static var XE_MainNetTransactionUrl = "https://index.xe.network/transactions/"
    static var XE_TestNetTransactionUrl = "https://index.test.network/transactions/"
    
    /// XE pending transaction Endpoints
    ///
    static var XE_MainNetPendingUrl = "https://api.xe.network/transactions/pending/"
    static var XE_TestNetPendingUrl = "https://xe1.test.network/transactions/pending/"
    
    /// XE send endpoint
    ///
    static var XE_MainNetSendUrl = "https://api.xe.network/transaction"
    static var XE_TestNetSendUrl = "https://xe1.test.network/transaction"
    

    static var XE_GasRatesUrl = "https://index.xe.network/gasrates"
    static var XE_ExchangeRatesUrl = "https://index.xe.network/exchangerate"
    static var XE_ExchangeRateCurrentUrl = "https://index.xe.network/token/current"
    static var XE_ExchangeRateHistoryUrl = "https://index.test.network/token/lastweek"
    
    static var XE_StakedAmountsUrl = "https://index.xe.network/stats/stakes"
    
    /// Transactions Pending endpoint
    ///
    static var XE_testTransactionPendingURL = "https://xe1.test.network/transactions/pending"
    static var XE_mainTransactionPendingURL = "https://api.xe.network/transactions/pending"

    /// Network labels for in app
    ///
    static var XE_networkMainNetTitle = "Edge (XE) Mainnet"
    static var XE_networkTestNetTitle = "Edge (XE) Testnet"
    
    /// Edge/xe bridge addresses
    ///
    static var XE_mainNetBridge = "xe_A4788d8201Fb879e3b7523a0367401D2a985D42F"
    static var XE_testNetBridge = "xe_BEE3d7E5f007b662B2C886d51e2B3E08de090488"
    
    /// TIMERS

    static var XE_GasPriceUpdateTime = 2.0
    static var WalletPageUpdateTimer = 2.0
    
    
    static var infuraToken = "f4953edd390547d3bb63dd1f76af13f2"
}
