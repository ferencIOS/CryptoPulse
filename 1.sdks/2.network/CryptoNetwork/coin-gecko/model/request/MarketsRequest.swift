//
//  MarketsRequest.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 15/03/24.
//

import Foundation

public struct MarketsRequest: Codable {
    public let currency: String
    public let order: String
    public let perPage: Int
    public let page: Int
    public let sparkline: Bool
    public let locale: String
    
    public init(
        currency: String = "eur",
        order: String = "market_cap_desc",
        perPage: Int = 10,
        page: Int = 1,
        sparkline: Bool = true,
        locale: String = "en"
    ) {
        self.currency = currency
        self.order = order
        self.perPage = perPage
        self.page = page
        self.sparkline = sparkline
        self.locale = locale
    }

    enum CodingKeys: String, CodingKey {
        case currency = "vs_currency"
        case order
        case perPage = "per_page"
        case page
        case sparkline
        case locale
    }
}
