//
//  EtherExchangeRatesDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 27/11/2021.
//

import Foundation
import web3swift

class EtherExchangeRatesManager {
    
    static let shared = EtherExchangeRatesManager()
    
    var exchangeDataModel: EtherExchangeRatesManager? = nil
    var timer: Timer?
    var etherValue: NSNumber = 0
    
    private init() {
        
        self.getCurrentEtherValue()
        self.timer = Timer.scheduledTimer(withTimeInterval: Constants.XE_GasPriceUpdateTime, repeats: true) { timer in
            
            self.getCurrentEtherValue()
        }
    }
    
    func getRateValue() -> NSNumber {
        
        return self.etherValue
    }
    
    func getCurrentEtherValue() {
        
        CurrencyType.eth.requestValue { (value) in
            
            DispatchQueue.global().async {
                
                self.etherValue = value ?? 0
            }
        }
    }
}
