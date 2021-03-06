//
//  GasRates.swift
//  xe_wallet
//
//  Created by Paul Davis on 23/11/2021.
//

import UIKit
import Alamofire

class XEGasRatesDataModel: Codable {

    var date: Int
    var fee: Int
    var ref: String
    var handlingFeePercentage: Double
    var minimumHandlingFee: Double
    var ethereum: XEGasRatesEthereumDataModel
        
    enum CodingKeys: String, CodingKey {
        
        case date
        case fee
        case ref
        case handlingFeePercentage
        case minimumHandlingFee
        case ethereum
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Int.self, forKey: .date)
        self.fee = try container.decode(Int.self, forKey: .fee)
        self.ref = try container.decode(String.self, forKey: .ref)
        self.handlingFeePercentage = try container.decode(Double.self, forKey: .handlingFeePercentage)
        self.minimumHandlingFee = try container.decode(Double.self, forKey: .minimumHandlingFee)
        self.ethereum = try container.decode(XEGasRatesEthereumDataModel.self, forKey: .ethereum)
    }
}

class XEGasRatesEthereumDataModel: Codable {

    var legacy: Double
    var baseFee: Double
    var priorityFee: Double
    
    enum CodingKeys: String, CodingKey {
        
        case legacy
        case baseFee
        case priorityFee
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.legacy = try container.decode(Double.self, forKey: .legacy)
        self.baseFee = try container.decode(Double.self, forKey: .baseFee)
        self.priorityFee = try container.decode(Double.self, forKey: .priorityFee)
    }
}



class XEGasRatesManager {

    static let shared = XEGasRatesManager()
    
    var gasDataModel: XEGasRatesDataModel? = nil
    var timer: Timer?
    var lastUpdateTime = Date()
    
    private init() {
        
        self.downloadGasRates()
        self.timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { timer in
            
            self.downloadGasRates()
        }
    }
    
    func configure() {
    }
    
    func getRates() -> XEGasRatesDataModel? {
        
        return self.gasDataModel
    }
    
    func hasUpdateInLastMinute(interval: TimeInterval) -> Bool {
        
        if Date().timeIntervalSince(self.lastUpdateTime) >= interval {
            
            return false
        }
        return true
    }
    
    func downloadGasRates() {
        
        Alamofire.request(WalletType.xe.getDataNetwork(dataType: .gasRates), method: .get, encoding: URLEncoding.queryString, headers: nil)
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

                    self.gasDataModel = try JSONDecoder().decode(XEGasRatesDataModel.self, from: response.data!)
                    self.lastUpdateTime = Date()
                    
                } catch let error as NSError {
                    print("Failed to load: \(String(describing: error))")
                }

                 case .failure(let error):
                    print("Request error: \(String(describing: error))")
             }
         }
    }
}





