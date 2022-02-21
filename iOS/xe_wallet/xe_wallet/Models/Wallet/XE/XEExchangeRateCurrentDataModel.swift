//
//  XEExchangeRateCurrentDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 21/02/2022.
//

import UIKit
import Alamofire
import web3swift
import SwiftyJSON

class XEExchangeRateCurrentDataModel: Codable {

    var date: String
    var ethPerXE: Double
    var usdPerXE: Double

    enum CodingKeys: String, CodingKey {
        
        case date
        case ethPerXE
        case usdPerXE
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.ethPerXE = try container.decode(Double.self, forKey: .ethPerXE)
        self.usdPerXE = try container.decode(Double.self, forKey: .usdPerXE)
    }
}

class XEExchangeRateCurrentManager {

    static let shared = XEExchangeRateCurrentManager()
    
    var exchangeDataModel: XEExchangeRateCurrentDataModel? = nil
    var timer: Timer?
    
    private init() {
        
        self.downloadExchangeRates()
        self.timer = Timer.scheduledTimer(withTimeInterval: Constants.XE_GasPriceUpdateTime, repeats: true) { timer in
            
            self.downloadExchangeRates()
        }
    }
    
    func configure() {
        
        self.loadFromLocalStorage()
    }
    
    func loadFromLocalStorage() {
        
        if let data = UserDefaults.standard.data(forKey: "ExchangeRateCurrent") {
            
            if let decoded = try? JSONDecoder().decode(XEExchangeRateCurrentDataModel.self, from: data) {

                self.exchangeDataModel = decoded
            }
        }
    }
    
    func saveToLocalStorage() {
        
        if let encoded = try? JSONEncoder().encode(self.exchangeDataModel) {
            
            UserDefaults.standard.set(encoded, forKey: "ExchangeRateCurrent")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getRates() -> XEExchangeRateCurrentDataModel? {
        
        return self.exchangeDataModel
    }
    
    func getUSDRate() -> NSNumber {
        
        if let rates = self.exchangeDataModel {
            
            return NSNumber(value: rates.usdPerXE)
        }
        return NSNumber(value:0.0)
    }

    
    func downloadExchangeRates() {
        
        Alamofire.request(Constants.XE_ExchangeRateCurrentUrl, method: .get, encoding: URLEncoding.queryString, headers: nil)
         .validate()
         .responseJSON { response in

             guard response.result.error == nil else {
                 print("error calling GET ")
                 print(response.result.error!)
                 return
             }
             
            switch (response.result) {

                case .success( _):

                do {

                    self.exchangeDataModel = try JSONDecoder().decode(XEExchangeRateCurrentDataModel.self, from: response.data!)
                    self.saveToLocalStorage()
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }

                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
             }
         }
    }
}


