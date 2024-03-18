//
//  EncodableExtension.swift
//  CryptoUtilities
//
//  Created by francesco scalise on 15/03/24.
//

import Foundation

public extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return dictionary as? [String: Any] ?? [:]
    }
    
    func asURLQueryItems() throws -> [URLQueryItem] {
        let dictionary = try self.asDictionary()
        return dictionary.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
    }
}
