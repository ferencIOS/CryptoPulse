//
//  CryptoDetails.swift
//  CryptoCore
//
//  Created by francesco scalise on 19/03/24.
//

import Foundation

public struct CryptoDetails: Identifiable {
    public let id: String
    public let currency: String
    public let symbol: String
    public let name: String
    public let description: String
    public let homepageURL: URL?
    public let historicalPrices: [Double]
    public let currentPrice: String
    public let priceChangePercentage24H: String
    public let imageURL: URL
    
    public init(id: String, currency: String, symbol: String, name: String, description: String, homepageURL: URL?, historicalPrices: [Double], currentPrice: String, priceChangePercentage24H: String, imageURL: URL) {
        self.id = id
        self.currency = currency
        self.symbol = symbol
        self.name = name
        self.description = description
        self.homepageURL = homepageURL
        self.historicalPrices = historicalPrices
        self.currentPrice = currentPrice
        self.priceChangePercentage24H = priceChangePercentage24H
        self.imageURL = imageURL
    }
}
