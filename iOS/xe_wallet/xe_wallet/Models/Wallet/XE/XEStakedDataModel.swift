//
//  XEStakedDataModel.swift
//  xe_wallet
//
//  Created by Paul Davis on 10/02/2022.
//

import UIKit
import Alamofire
import web3swift

class XEStakedDataModel: Codable {

    var count: Int
    var stakedAmount: Double

    enum CodingKeys: String, CodingKey {
        
        case count
        case stakedAmount
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.stakedAmount = try container.decode(Double.self, forKey: .stakedAmount)
    }
}

class XEStakedDataManagerManager {

    static let shared = XEStakedDataManagerManager()
    
    var xeStakedDataModel: XEStakedDataModel? = nil
    var timer: Timer?
    
    private init() {
        
        self.downloadStakedData()
        self.timer = Timer.scheduledTimer(withTimeInterval: Constants.XE_GasPriceUpdateTime, repeats: true) { timer in
            
            self.downloadStakedData()
        }
    }
    
    func configure() {
        
    }
    
    func getStakeData() -> XEStakedDataModel? {
        
        return self.xeStakedDataModel
    }
        
    func downloadStakedData() {
        
        Alamofire.request(Constants.XE_StakedAmountsUrl, method: .get, encoding: URLEncoding.queryString, headers: nil)
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

                    self.xeStakedDataModel = try JSONDecoder().decode(XEStakedDataModel.self, from: response.data!)

                } catch let error as NSError {
                    print("Failed to load: \(String(describing: error))")
                }

                 case .failure(let error):
                    print("Request error: \(String(describing: error))")
             }
         }
    }
}

