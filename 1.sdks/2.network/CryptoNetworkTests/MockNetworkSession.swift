//
//  MockNetworkSession.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 18/03/24.
//

import XCTest
@testable import CryptoNetwork

class MockNetworkSession: NetworkSession {
    var mockResponse: Any?
    var mockError: Error?

    func load<A>(_ endpoint: Endpoint<A>) async throws -> A {
        if let error = mockError {
            throw error
        }
        guard let response = mockResponse as? A else {
            fatalError("Mock response not set or has incorrect type.")
        }
        return response
    }
}

class CoinGeckoServiceTests: XCTestCase {
    
    let mockMarketsResponse = MarketsResponse([
        Market(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            image: URL(string: "https://example.com/bitcoin.png")!,
            currentPrice: 42000.0,
            marketCap: 800000000000,
            marketCapRank: 1,
            fullyDilutedValuation: 840000000000,
            totalVolume: 35000000000,
            high24h: 43000.0,
            low24h: 41000.0,
            priceChange24h: -1000.0,
            priceChangePercentage24h: -2.3,
            marketCapChange24h: -20000000000,
            marketCapChangePercentage24h: -2.5,
            circulatingSupply: 18000000,
            totalSupply: 21000000,
            maxSupply: 21000000,
            ath: 69000.0,
            athChangePercentage: -39.13,
            athDate: "2021-11-10T00:00:00Z",
            atl: 67.81,
            atlChangePercentage: 61832.94,
            atlDate: "2013-07-06T00:00:00Z",
            roi: nil,
            lastUpdated: "2022-01-01T00:00:00Z"
        )
    ])
    
    let mockMarketDetailsResponse = MarketDetailsResponse(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        description: "Bitcoin is a cryptocurrency invented in 2008...",
        links: MarketDetailsResponse.Links(
            homepage: ["https://bitcoin.org"],
            officialForumUrl: ["https://bitcointalk.org"]
        ),
        marketData: MarketDetailsResponse.Data(
            currentPrice: ["usd": 42000.0],
            historicalData: [
                MarketDetailsResponse.HistoricalData(prices: [[1609459200000, 29000.0], [1609545600000, 29400.0]])
            ]
        )
    )
    
    let mockMarketChartResponse = MarketChartResponse(
        prices: [[1609459200000, 29000.0], [1609545600000, 29400.0]],
        marketCaps: [[1609459200000, 540000000000], [1609545600000, 550000000000]],
        totalVolumes: [[1609459200000, 35000000000], [1609545600000, 36000000000]]
    )

    var service: CoinGeckoService!
    var mockSession: MockNetworkSession!

    override func setUp() {
        super.setUp()
        mockSession = MockNetworkSession()
        service = CoinGeckoService(session: mockSession)
    }

    func testFetchMarketsFailure() async throws {
        mockSession.mockError = NSError(domain: "TestError", code: -1, userInfo: nil)

        do {
            _ = try await service.fetchMarkets(request: MarketsRequest())
            XCTFail("Expected error, but received successful response")
        } catch {
            // You might want to assert specific error handling here
        }
    }

    func testFetchMarketsSuccess() async throws {
        mockSession.mockResponse = mockMarketsResponse

        do {
            let response = try await service.fetchMarkets(request: MarketsRequest())
            XCTAssertEqual(response.count, mockMarketsResponse.count)
            XCTAssertEqual(response.first?.name, "Bitcoin")
        } catch {
            XCTFail("Expected successful response, but received error: \(error)")
        }
    }
    
    func testFetchMarketDetailsSuccess() async throws {
        mockSession.mockResponse = mockMarketDetailsResponse

        do {
            let response = try await service.fetchMarketDetails(request: MarketDetailsRequest(id: "bitcoin"))
            XCTAssertEqual(response.name, "Bitcoin")
            XCTAssertEqual(response.marketData.currentPrice["usd"], 42000.0)
        } catch {
            XCTFail("Expected successful response, but received error: \(error)")
        }
    }


    func testFetchMarketChartSuccess() async throws {
        mockSession.mockResponse = mockMarketChartResponse
        
        do {
            let response = try await service.fetchMarketChart(request: MarketChartRequest(id: "bitcoin"))
            XCTAssertFalse(response.prices.isEmpty)
            XCTAssertEqual(response.prices.first?[1], 29000.0)
        } catch {
            XCTFail("Expected successful response, but received error: \(error)")
        }
    }
    
}
