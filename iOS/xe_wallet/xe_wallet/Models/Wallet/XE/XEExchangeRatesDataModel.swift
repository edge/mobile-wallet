//
//  ExchangeRatesDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/11/2021.
//

import UIKit
import Alamofire
import web3swift

class XEExchangeRatesDataModel: Codable {

    var date: String
    var ref: String
    var rate: Double
    var gas: Int
    var limit: Double

    enum CodingKeys: String, CodingKey {
        
        case date
        case ref
        case rate
        case gas
        case limit
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.ref = try container.decode(String.self, forKey: .ref)
        self.rate = try container.decode(Double.self, forKey: .rate)
        self.gas = try container.decode(Int.self, forKey: .gas)
        self.limit = try container.decode(Double.self, forKey: .limit)
    }
}

class XEExchangeRatesManager {

    static let shared = XEExchangeRatesManager()
    
    var exchangeDataModel: XEExchangeRatesDataModel? = nil
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
        
        if let data = UserDefaults.standard.data(forKey: "ExchangeRates") {
            
            if let decoded = try? JSONDecoder().decode(XEExchangeRatesDataModel.self, from: data) {

                self.exchangeDataModel = decoded
            }
        }
    }
    
    func saveToLocalStorage() {
        
        if let encoded = try? JSONEncoder().encode(self.exchangeDataModel) {
            
            UserDefaults.standard.set(encoded, forKey: "ExchangeRates")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getRates() -> XEExchangeRatesDataModel? {
        
        return self.exchangeDataModel
    }
    
    func getRateValue() -> NSNumber {
        
        if let rates = self.exchangeDataModel {
            
            return NSNumber(value: rates.rate)
        }
        return 0
    }
        
    func downloadExchangeRates() {
        
        Alamofire.request(Constants.XE_ExchangeRatesUrl, method: .get, encoding: URLEncoding.queryString, headers: nil)
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

                    self.exchangeDataModel = try JSONDecoder().decode(XEExchangeRatesDataModel.self, from: response.data!)
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
