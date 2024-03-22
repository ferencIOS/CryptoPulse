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

/**
 
 [{"id":"bitcoin","symbol":"btc","name":"Bitcoin","image":"https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400","current_price":61355,"market_cap":1206208681112,"market_cap_rank":1,"fully_diluted_valuation":1288398570858,"total_volume":55026750582,"high_24h":62316,"low_24h":57185,"price_change_24h":2801.67,"price_change_percentage_24h":4.78481,"market_cap_change_24h":53016049911,"market_cap_change_percentage_24h":4.59733,"circulating_supply":19660362.0,"total_supply":21000000.0,"max_supply":21000000.0,"ath":67405,"ath_change_percentage":-8.59177,"ath_date":"2024-03-14T07:10:36.635Z","atl":51.3,"atl_change_percentage":120009.16396,"atl_date":"2013-07-05T00:00:00.000Z","roi":null,"last_updated":"2024-03-21T13:53:57.620Z"},{"id":"ethereum","symbol":"eth","name":"Ethereum","image":"https://assets.coingecko.com/coins/images/279/large/ethereum.png?1696501628","current_price":3237.5,"market_cap":388810251074,"market_cap_rank":2,"fully_diluted_valuation":388810251074,"total_volume":31922580117,"high_24h":3281.08,"low_24h":2937.98,"price_change_24h":151.16,"price_change_percentage_24h":4.89775,"market_cap_change_24h":17857554648,"market_cap_change_percentage_24h":4.81397,"circulating_supply":120074313.051938,"total_supply":120074313.051938,"max_supply":null,"ath":4228.93,"ath_change_percentage":-23.20537,"ath_date":"2021-12-01T08:38:24.623Z","atl":0.381455,"atl_change_percentage":851268.57902,"atl_date":"2015-10-20T00:00:00.000Z","roi":{"times":69.50651248404263,"currency":"btc","percentage":6950.651248404262},"last_updated":"2024-03-21T13:53:47.248Z"},{"id":"tether","symbol":"usdt","name":"Tether","image":"https://assets.coingecko.com/coins/images/325/large/Tether.png?1696501661","current_price":0.915505,"market_cap":95124675931,"market_cap_rank":3,"fully_diluted_valuation":95124675931,"total_volume":68209867523,"high_24h":0.926241,"low_24h":0.909579,"price_change_24h":-0.006330189074564397,"price_change_percentage_24h":-0.68669,"market_cap_change_24h":-663430892.289856,"market_cap_change_percentage_24h":-0.6926,"circulating_supply":103904029582.796,"total_supply":103904029582.796,"max_supply":null,"ath":1.13,"ath_change_percentage":-18.92552,"ath_date":"2018-07-24T00:00:00.000Z","atl":0.533096,"atl_change_percentage":72.09646,"atl_date":"2015-03-02T00:00:00.000Z","roi":null,"last_updated":"2024-03-21T13:50:33.197Z"},{"id":"binancecoin","symbol":"bnb","name":"BNB","image":"https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png?1696501970","current_price":514.67,"market_cap":79076826302,"market_cap_rank":4,"fully_diluted_valuation":79076826302,"total_volume":2952578527,"high_24h":520.04,"low_24h":464.72,"price_change_24h":25.77,"price_change_percentage_24h":5.27071,"market_cap_change_24h":3771870396,"market_cap_change_percentage_24h":5.00879,"circulating_supply":153856150.0,"total_supply":153856150.0,"max_supply":200000000.0,"ath":586.39,"ath_change_percentage":-12.25733,"ath_date":"2024-03-16T00:10:54.176Z","atl":0.03359941,"atl_change_percentage":1531230.87517,"atl_date":"2017-10-19T00:00:00.000Z","roi":null,"last_updated":"2024-03-21T13:53:51.191Z"},{"id":"solana","symbol":"sol","name":"Solana","image":"https://assets.coingecko.com/coins/images/4128/large/solana.png?1696504756","current_price":172.8,"market_cap":76587848808,"market_cap_rank":5,"fully_diluted_valuation":98723865894,"total_volume":7531247719,"high_24h":177.13,"low_24h":153.77,"price_change_24h":13.98,"price_change_percentage_24h":8.8026,"market_cap_change_24h":6047892681,"market_cap_change_percentage_24h":8.57371,"circulating_supply":443964734.328275,"total_supply":572282882.674173,"max_supply":null,"ath":225.04,"ath_change_percentage":-22.90661,"ath_date":"2021-11-06T21:54:35.825Z","atl":0.46316,"atl_change_percentage":37358.70646,"atl_date":"2020-05-11T19:35:23.449Z","roi":null,"last_updated":"2024-03-21T13:54:10.292Z"},{"id":"staked-ether","symbol":"steth","name":"Lido Staked Ether","image":"https://assets.coingecko.com/coins/images/13442/large/steth_logo.png?1696513206","current_price":3231.93,"market_cap":31641215311,"market_cap_rank":6,"fully_diluted_valuation":31641215311,"total_volume":89646193,"high_24h":3279.98,"low_24h":2926.94,"price_change_24h":152.71,"price_change_percentage_24h":4.95922,"market_cap_change_24h":1530433953,"market_cap_change_percentage_24h":5.08268,"circulating_supply":9783303.36100505,"total_supply":9783303.36100505,"max_supply":null,"ath":4188.52,"ath_change_percentage":-22.40269,"ath_date":"2021-11-12T02:16:02.325Z","atl":394.87,"atl_change_percentage":723.11019,"atl_date":"2020-12-22T04:08:21.854Z","roi":null,"last_updated":"2024-03-21T13:53:30.599Z"},{"id":"ripple","symbol":"xrp","name":"XRP","image":"https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png?1696501442","current_price":0.567764,"market_cap":31154299239,"market_cap_rank":7,"fully_diluted_valuation":56756703962,"total_volume":2279190142,"high_24h":0.569134,"low_24h":0.525032,"price_change_24h":0.01985164,"price_change_percentage_24h":3.62314,"market_cap_change_24h":1114762093,"market_cap_change_percentage_24h":3.71098,"circulating_supply":54884241878.0,"total_supply":99987762348.0,"max_supply":100000000000.0,"ath":2.82,"ath_change_percentage":-79.96432,"ath_date":"2018-01-07T00:00:00.000Z","atl":0.00194619,"atl_change_percentage":28962.53411,"atl_date":"2013-08-16T00:00:00.000Z","roi":null,"last_updated":"2024-03-21T13:53:55.854Z"},{"id":"usd-coin","symbol":"usdc","name":"USDC","image":"https://assets.coingecko.com/coins/images/6319/large/usdc.png?1696506694","current_price":0.916419,"market_cap":28994711912,"market_cap_rank":8,"fully_diluted_valuation":29015114327,"total_volume":12230927797,"high_24h":0.930143,"low_24h":0.90923,"price_change_24h":-0.005619678626935243,"price_change_percentage_24h":-0.60948,"market_cap_change_24h":163234147,"market_cap_change_percentage_24h":0.56617,"circulating_supply":31641612805.407,"total_supply":31663877738.893,"max_supply":null,"ath":1.059,"ath_change_percentage":-13.57285,"ath_date":"2022-09-27T16:25:08.674Z","atl":0.730265,"atl_change_percentage":25.35686,"atl_date":"2021-05-19T13:14:05.611Z","roi":null,"last_updated":"2024-03-21T13:53:59.155Z"},{"id":"cardano","symbol":"ada","name":"Cardano","image":"https://assets.coingecko.com/coins/images/975/large/cardano.png?1696502090","current_price":0.579139,"market_cap":20382042369,"market_cap_rank":9,"fully_diluted_valuation":26022173618,"total_volume":754409466,"high_24h":0.591756,"low_24h":0.533965,"price_change_24h":0.01954465,"price_change_percentage_24h":3.49265,"market_cap_change_24h":643529685,"market_cap_change_percentage_24h":3.26027,"circulating_supply":35246552423.2316,"total_supply":45000000000.0,"max_supply":45000000000.0,"ath":2.61,"ath_change_percentage":-77.74674,"ath_date":"2021-09-02T06:00:10.474Z","atl":0.01722339,"atl_change_percentage":3267.89552,"atl_date":"2020-03-13T02:22:55.044Z","roi":null,"last_updated":"2024-03-21T13:54:06.359Z"},{"id":"dogecoin","symbol":"doge","name":"Dogecoin","image":"https://assets.coingecko.com/coins/images/5/large/dogecoin.png?1696501409","current_price":0.140279,"market_cap":20119149165,"market_cap_rank":10,"fully_diluted_valuation":20121875369,"total_volume":3062356691,"high_24h":0.14339,"low_24h":0.117526,"price_change_24h":0.01673801,"price_change_percentage_24h":13.54858,"market_cap_change_24h":2354224512,"market_cap_change_percentage_24h":13.25209,"circulating_supply":143539316383.705,"total_supply":143559356383.705,"max_supply":null,"ath":0.601466,"ath_change_percentage":-76.62287,"ath_date":"2021-05-08T05:08:23.458Z","atl":7.662e-05,"atl_change_percentage":183418.73452,"atl_date":"2015-05-06T00:00:00.000Z","roi":null,"last_updated":"2024-03-21T13:54:01.670Z"}]
 
 */
