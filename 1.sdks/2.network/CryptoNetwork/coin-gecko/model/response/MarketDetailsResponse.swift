//
//  MarketDetailsResponse.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 18/03/24.
//

import Foundation

extension MarketDetailsResponse {
    public typealias Locale = String
}

public struct MarketDetailsResponse: Codable {
    public let id: String
    public let symbol: String
    public let name: String
    public let description: [MarketDetailsResponse.Locale: String]
    public let links: MarketDetailsResponse.Links
    public let marketData: MarketDetailsResponse.Data
    public let image: MarketDetailsResponse.Image
    
    public init(id: String, symbol: String, name: String, description: [MarketDetailsResponse.Locale: String], links: MarketDetailsResponse.Links, marketData: MarketDetailsResponse.Data, image: MarketDetailsResponse.Image) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.description = description
        self.links = links
        self.marketData = marketData
        self.image = image
    }

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case description
        case links
        case marketData = "market_data"
        case image
    }
}

extension MarketDetailsResponse {
    public struct Links: Codable {
        public let homepage: [String]
        public let officialForumUrl: [String]
        
        public init(homepage: [String], officialForumUrl: [String]) {
            self.homepage = homepage
            self.officialForumUrl = officialForumUrl
        }
        
        enum CodingKeys: String, CodingKey {
            case homepage
            case officialForumUrl = "official_forum_url"
        }
    }
    
    public struct Data: Codable {
        public let currentPrice: [String: Double]
        public let historicalData: HistoricalData
        
        public init(currentPrice: [String : Double], historicalData: HistoricalData) {
            self.currentPrice = currentPrice
            self.historicalData = historicalData
        }
        
        enum CodingKeys: String, CodingKey {
            case currentPrice = "current_price"
            case historicalData = "sparkline_7d"
        }
    }
    
    public struct HistoricalData: Codable {
        public let price: [Double]
        
        public init(price: [Double]) {
            self.price = price
        }
    }
    
    public struct Image: Codable {
        public let large: URL
        
        public init(large: URL) {
            self.large = large
        }
    }
    
}
