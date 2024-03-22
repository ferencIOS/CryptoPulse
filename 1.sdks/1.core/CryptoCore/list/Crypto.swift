//
//  Market.swift
//  CryptoCore
//
//  Created by francesco scalise on 19/03/24.
//

import Foundation

public struct Crypto: Identifiable {
    public let id: String
    public let currency: String
    public let name: String
    public let symbol: String
    public let imageUrl: URL
    public let currentPrice: String
    public let priceChangePercentage24H: String

    public init(id: String, currency: String, name: String, symbol: String, imageUrl: URL, currentPrice: String, priceChangePercentage24H: String) {
        self.id = id
        self.currency = currency
        self.name = name
        self.symbol = symbol
        self.imageUrl = imageUrl
        self.currentPrice = currentPrice
        self.priceChangePercentage24H = priceChangePercentage24H
    }
}

