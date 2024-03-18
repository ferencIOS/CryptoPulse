//
//  CoinGeckoService.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 15/03/24.
//

import Foundation

public protocol CoinGeckoServiceProtocol {
    func fetchMarkets(request: MarketsRequest) async throws -> MarketsResponse
    func fetchMarketDetails(request: MarketDetailsRequest) async throws -> MarketDetailsResponse
    func fetchMarketChart(request: MarketChartRequest) async throws -> MarketChartResponse
}

public class CoinGeckoService: CoinGeckoServiceProtocol {
    private let session: NetworkSession
    
    public init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
}

// MARK: - markets

extension CoinGeckoService {

    public func fetchMarkets(request: MarketsRequest) async throws -> MarketsResponse {
        let url = URL(string: "\(CoinGeckoAPI.baseURL)\(CoinGeckoAPICall.markets)")!
        let queryItems = try request.asURLQueryItems()
        
        let endpoint = Endpoint<MarketsResponse>(
            json: .get,
            url: url,
            queryItems: queryItems
        )
        
        return try await session.load(endpoint)
    }
}

// MARK: - market details

extension CoinGeckoService {

    public func fetchMarketDetails(request: MarketDetailsRequest) async throws -> MarketDetailsResponse {
        let url = URL(string: "\(CoinGeckoAPI.baseURL)\(CoinGeckoAPICall.coins)/\(request.id)")!
        
        let endpoint = Endpoint<MarketDetailsResponse>(
            json: .get,
            url: url,
            queryItems: []
        )
        
        return try await session.load(endpoint)
    }
}

extension CoinGeckoService {

    public func fetchMarketChart(request: MarketChartRequest) async throws -> MarketChartResponse {
        let url = URL(string: "\(CoinGeckoAPI.baseURL)\(CoinGeckoAPICall.coins)/\(request.id)/market_chart")!
        let queryItems = try request.asURLQueryItems()
        
        let endpoint = Endpoint<MarketChartResponse>(
            json: .get,
            url: url,
            queryItems: queryItems
        )
        
        return try await session.load(endpoint)
    }
}

/**
 class MockSession: NetworkSession {
     var mockResponse: [MarketsResponse]?

     func load<A>(_ endpoint: Endpoint<A>) async throws -> A {
         guard let response = mockResponse as? A else {
             throw URLError(.cannotParseResponse)
         }
         return response
     }
 }

 class CoinGeckoServiceTests: XCTestCase {
     func testFetchMarkets() async throws {
         let service = CoinGeckoService(session: MockSession())
         let mockData: [MarketsResponse] = [...] // Your mock data
         (service.session as? MockSession)?.mockResponse = mockData

         do {
             let response = try await service.fetchMarkets(request: MarketsRequest(vsCurrency: "usd", order: "market_cap_desc", perPage: 10, page: 1, sparkline: false, locale: "en"))
             XCTAssertEqual(response, mockData)
         } catch {
             XCTFail("Fetching markets failed with error: \(error)")
         }
     }
 }

 
 
 */
