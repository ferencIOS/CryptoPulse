//
//  MarketChartResponse.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 18/03/24.
//

import Foundation

public struct MarketChartResponse: Codable {
    public let prices: [[Double]]
    public let marketCaps: [[Double]]
    public let totalVolumes: [[Double]]

    enum CodingKeys: String, CodingKey {
        case prices
        case marketCaps = "market_caps"
        case totalVolumes = "total_volumes"
    }
}
