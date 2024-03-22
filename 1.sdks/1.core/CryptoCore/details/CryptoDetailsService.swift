//
//  CryptoDetailsService.swift
//  CryptoCore
//
//  Created by francesco scalise on 19/03/24.
//

import Foundation
import CryptoNetwork

public protocol CryptoDetailsServiceProtocol {
    func fetchCryptoDetails(for crypto: Crypto) async throws -> CryptoDetails
}

public final class CryptoDetailsService: CryptoDetailsServiceProtocol {
    private let coinGeckoService: CoinGeckoServiceProtocol
    
    public init(coinGeckoService: CoinGeckoServiceProtocol = CoinGeckoService()) {
        self.coinGeckoService = coinGeckoService
    }
    
    public func fetchCryptoDetails(for crypto: Crypto) async throws -> CryptoDetails {
        do {
            let id = crypto.id
            
            let marketDetailsRequest = MarketDetailsRequest(id: id)
            let marketDetailsResponse = try await coinGeckoService.fetchMarketDetails(request: marketDetailsRequest)
            
            let marketChartRequest = MarketChartRequest(id: id)
            let marketChartResponse = try await coinGeckoService.fetchMarketChart(request: marketChartRequest)
            
            return .init(crypto: crypto, marketDetails: marketDetailsResponse, marketChart: marketChartResponse)
            
        } catch let error as WrongStatusCodeError where error.statusCode == 429 {
            // Assuming `WrongStatusCodeError` includes the necessary response details
            let retryAfterSeconds = error.response?.value(forHTTPHeaderField: "Retry-After").flatMap(Int.init) ?? 60 // Default retry after 60 seconds
            throw NetworkError.rateLimited(retryAfter: retryAfterSeconds)
        } catch {
            // Re-throw other errors
            throw error
        }
    }
}

private extension CryptoDetails {
    
    init(crypto: Crypto, marketDetails: MarketDetailsResponse, marketChart: MarketChartResponse) {
        self.id = marketDetails.id
        self.currency = crypto.currency
        self.symbol = marketDetails.symbol
        self.name = marketDetails.name
        self.description = marketDetails.description["en"] ?? ""
        self.homepageURL = URL(string: marketDetails.links.homepage.first ?? "")
        self.historicalPrices = marketChart.prices.map { $0.last ?? 0.0 }
        self.currentPrice = crypto.currentPrice
        self.priceChangePercentage24H = crypto.priceChangePercentage24H
        self.imageURL = marketDetails.image.large
    }
}

#if DEBUG

public class MockCryptoDetailsService: CryptoDetailsServiceProtocol {
    public init() {}
    
    public func fetchCryptoDetails(for crypto: Crypto) async throws -> CryptoDetails {
        let id = crypto.id
        let currency = crypto.currency
        
        return CryptoDetails(
            id: id,
            currency: currency,
            symbol: "BTC",
            name: "Bitcoin",
            description: "Bitcoin è una criptovaluta inventata nel 2008 da una persona o un gruppo di persone con lo pseudonimo di Satoshi Nakamoto.\nBitcoin è una criptovaluta inventata nel 2008 da una persona o un gruppo di persone con lo pseudonimo di Satoshi Nakamoto.\nBitcoin è una criptovaluta inventata nel 2008 da una persona o un gruppo di persone con lo pseudonimo di Satoshi Nakamoto.",
            homepageURL: URL(string: "https://bitcoin.org"),
            historicalPrices: [30000.0, 31000.0, 32000.0, 31500.0, 33000.0, 34000.0, 500.0],
            currentPrice: crypto.currentPrice,
            priceChangePercentage24H: crypto.priceChangePercentage24H,
            imageURL: URL(string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png")!
        )
    }
}

#endif
