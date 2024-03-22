//
//  MarketDetailsResponse.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 18/03/24.
//

import Foundation

public struct MarketDetailsResponse: Codable {
    public let id: String
    public let symbol: String
    public let name: String
    public let description: String
    public let links: MarketDetailsResponse.Links
    public let marketData: MarketDetailsResponse.Data

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case description
        case links
        case marketData = "market_data"
    }
}

extension MarketDetailsResponse {
    public struct Links: Codable {
        public let homepage: [String]
        public let officialForumUrl: [String]
        
        enum CodingKeys: String, CodingKey {
            case homepage
            case officialForumUrl = "official_forum_url"
        }
    }
    
    public struct Data: Codable {
        public let currentPrice: [String: Double]
        public let historicalData: [HistoricalData]
        
        enum CodingKeys: String, CodingKey {
            case currentPrice = "current_price"
            case historicalData = "sparkline_7d"
        }
    }
    
    public struct HistoricalData: Codable {
        public let prices: [[Double]]
    }
    
}
