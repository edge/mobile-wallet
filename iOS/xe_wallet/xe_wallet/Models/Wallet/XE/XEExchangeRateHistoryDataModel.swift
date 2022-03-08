//
//  XEExchangeRateHistoryDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 01/02/2022.
//

import UIKit
import Alamofire
import web3swift
import SwiftyJSON

class XEExchangeRateHistoryDataModel: Codable {

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

class XEExchangeRateHistoryManager {

    static let shared = XEExchangeRateHistoryManager()
    
    var exchangeDataModel: [XEExchangeRateHistoryDataModel]? = nil
    var timer: Timer?
    
    private init() {
        
        self.downloadExchangeRates()
        self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            
            self.downloadExchangeRates()
        }
    }
    
    func configure() {
        
        self.loadFromLocalStorage()
    }
    
    func loadFromLocalStorage() {
        
        if let data = UserDefaults.standard.data(forKey: "ExchangeRateHistory") {
            
            if let decoded = try? JSONDecoder().decode([XEExchangeRateHistoryDataModel].self, from: data) {

                self.exchangeDataModel = decoded
            }
        }
    }
    
    func saveToLocalStorage() {
        
        if let encoded = try? JSONEncoder().encode(self.exchangeDataModel) {
            
            UserDefaults.standard.set(encoded, forKey: "ExchangeRateHistory")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getRates() -> [XEExchangeRateHistoryDataModel]? {
        
        return self.exchangeDataModel
    }
    
    func getRates(type: WalletType) -> [Double]? {
        
        var array: [Double] = []
        
        if let rates = self.exchangeDataModel {
            
            for rate in rates {
                
                if type == .edge {
                    
                    array.append(rate.usdPerXE)
                } else if type == .ethereum {
                    
                    let usdPerEth = rate.usdPerXE / rate.ethPerXE
                    array.append(usdPerEth)
                }
            }
        }
        return array
    }
    
    func getRatePerformanceImage(type: WalletType) -> UIImage? {
        
        if let rates = self.exchangeDataModel {
            
            if rates.count > 1 {
               
                if type == .edge || type == .xe {
                    
                    if rates[rates.count-1].usdPerXE < rates[rates.count-2].usdPerXE {
                        
                        return UIImage(named:"trendlineDown")
                    }
                } else if type == .ethereum {
                    
                    if (rates[rates.count-1].usdPerXE / rates[rates.count-1].ethPerXE) < (rates[rates.count-2].usdPerXE / rates[rates.count-2].ethPerXE) {
                        
                        return UIImage(named:"trendlineDown")
                    }
                }
            }
        }
        return UIImage(named:"trendlineUp")
    }
    
    func getRateHistoryPercentage(type: WalletType) -> Double {
        
        if let rates = self.exchangeDataModel {
            
            if rates.count > 1 {
            
                if type == .edge || type == .xe {
                
                    let last = rates[0].usdPerXE
                    let second = rates[1].usdPerXE
                    
                    return ((last - second) / second ) * 100
                } else if type == .ethereum {
                    
                    let last = rates[0].usdPerXE / rates[rates.count-1].ethPerXE
                    let second = rates[1].usdPerXE / rates[rates.count-2].ethPerXE
                    return ((last - second) / second ) * 100
                }
            }
        }
        return 0
    }
        
    func downloadExchangeRates() {
        
        Alamofire.request(WalletType.xe.getDataNetwork(dataType: .gasExchangeHistory), method: .get, encoding: URLEncoding.queryString, headers: nil)
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

                    self.exchangeDataModel = try JSONDecoder().decode([XEExchangeRateHistoryDataModel].self, from: response.data!)
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

