//
//  CryptoListService.swift
//  CryptoCore
//
//  Created by francesco scalise on 19/03/24.
//

import Foundation
import CryptoNetwork

public enum NetworkError: Error {
    case rateLimited(retryAfter: Int)
}

public protocol CryptoListServiceProtocol {
    func fetchTopCryptos() async throws -> [Crypto]
}

public final class CryptoListService: CryptoListServiceProtocol {
    private let coinGeckoService: CoinGeckoServiceProtocol
    
    public init(coinGeckoService: CoinGeckoServiceProtocol = CoinGeckoService()) {
        self.coinGeckoService = coinGeckoService
    }
}

extension CryptoListService {
    
    public func fetchTopCryptos() async throws -> [Crypto] {
        do {
            let request = MarketsRequest()
            let response = try await coinGeckoService.fetchMarkets(request: request)
            return response.map(Crypto.init)
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

private extension Crypto {
    init(from market: CryptoNetwork.Market) {
        self.id = market.id
        self.currency = "EUR"
        self.name = market.name
        self.symbol = market.symbol.uppercased()
        self.imageUrl = market.image
        self.currentPrice = Crypto.formatPrice(market.currentPrice)
        let priceChangeFormatted = String(format: "%.2f", market.priceChangePercentage24h)
        self.priceChangePercentage24H = "\(priceChangeFormatted)%"
    }
    
    private static func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}

#if DEBUG

public class MockCryptoListService: CryptoListServiceProtocol {
    public init() {}
    
    public func fetchTopCryptos() async throws -> [Crypto] {
        return [
            Crypto(id: "bitcoin", currency: "EUR", name: "Bitcoin", symbol: "BTC", imageUrl: URL(string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png")!, currentPrice: "€30,000", priceChangePercentage24H: "-500.32%"),
            Crypto(id: "ethereum", currency: "EUR", name: "Ethereum", symbol: "ETH", imageUrl: URL(string: "https://assets.coingecko.com/coins/images/279/large/ethereum.png")!, currentPrice: "€2,000", priceChangePercentage24H: "300.10%"),
        ]
    }
}

#endif
