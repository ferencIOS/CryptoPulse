//
//  MarketChartRequest.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 18/03/24.
//

import Foundation

public struct MarketChartRequest: Codable {
    public let id: String
    public let currency: String
    public let days: String
    public let interval: String // optional based on API, can be "daily", etc.
    
    public init(id: String, currency: String = "eur", days: String = "7", interval: String = "daily") {
        self.id = id
        self.currency = currency
        self.days = days
        self.interval = interval
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case currency = "vs_currency"
        case days
        case interval
    }
}
