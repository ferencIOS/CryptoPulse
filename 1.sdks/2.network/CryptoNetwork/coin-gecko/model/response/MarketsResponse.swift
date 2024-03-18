//
//  MarketsResponse.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 15/03/24.
//

import Foundation

public typealias MarketsResponse = [Market]

public struct Market: Codable {
    public let id: String
    public let symbol: String
    public let name: String
    public let image: URL
    public let currentPrice: Double
    public let marketCap: Double
    public let marketCapRank: Int
    public let fullyDilutedValuation: Double?
    public let totalVolume: Double
    public let high24h: Double
    public let low24h: Double
    public let priceChange24h: Double
    public let priceChangePercentage24h: Double
    public let marketCapChange24h: Double
    public let marketCapChangePercentage24h: Double
    public let circulatingSupply: Double
    public let totalSupply: Double?
    public let maxSupply: Double?
    public let ath: Double
    public let athChangePercentage: Double
    public let athDate: String
    public let atl: Double
    public let atlChangePercentage: Double
    public let atlDate: String
    public let roi: Market.Roi?
    public let lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCapChange24h = "market_cap_change_24h"
        case marketCapChangePercentage24h = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
    }
    
    public init(id: String, symbol: String, name: String, image: URL, currentPrice: Double, marketCap: Double, marketCapRank: Int, fullyDilutedValuation: Double?, totalVolume: Double, high24h: Double, low24h: Double, priceChange24h: Double, priceChangePercentage24h: Double, marketCapChange24h: Double, marketCapChangePercentage24h: Double, circulatingSupply: Double, totalSupply: Double?, maxSupply: Double?, ath: Double, athChangePercentage: Double, athDate: String, atl: Double, atlChangePercentage: Double, atlDate: String, roi: Market.Roi?, lastUpdated: String) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.fullyDilutedValuation = fullyDilutedValuation
        self.totalVolume = totalVolume
        self.high24h = high24h
        self.low24h = low24h
        self.priceChange24h = priceChange24h
        self.priceChangePercentage24h = priceChangePercentage24h
        self.marketCapChange24h = marketCapChange24h
        self.marketCapChangePercentage24h = marketCapChangePercentage24h
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.ath = ath
        self.athChangePercentage = athChangePercentage
        self.athDate = athDate
        self.atl = atl
        self.atlChangePercentage = atlChangePercentage
        self.atlDate = atlDate
        self.roi = roi
        self.lastUpdated = lastUpdated
    }
}

extension Market {
    
    public struct Roi: Codable {
        public let times: Double
        public let currency: String
        public let percentage: Double
        
        public init(times: Double, currency: String, percentage: Double) {
            self.times = times
            self.currency = currency
            self.percentage = percentage
        }
    }
    
}
