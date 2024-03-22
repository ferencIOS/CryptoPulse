//
//  MarketDetailsRequest.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 18/03/24.
//

import Foundation

public struct MarketDetailsRequest: Codable {
    public let id: String
    public let sparkline: Bool
    
    public init(id: String, sparkline: Bool = true) {
        self.id = id
        self.sparkline = sparkline
    }
}
