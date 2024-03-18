//
//  NetworkSession.swift
//  CryptoNetwork
//
//  Created by francesco scalise on 15/03/24.
//

import Foundation

public protocol NetworkSession {
    func load<A>(_ endpoint: Endpoint<A>) async throws -> A
}

extension URLSession: NetworkSession { }
