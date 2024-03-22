//
//  EncodableExtension.swift
//  CryptoUtilities
//
//  Created by francesco scalise on 15/03/24.
//

import Foundation

extension Encodable {
    public func asDictionary(excluding keys: [String] = []) throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        var dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [:]
        
        keys.forEach { dictionary.removeValue(forKey: $0) }
        
        return dictionary
    }
    
    public func asURLQueryItems(excluding keys: [String] = []) throws -> [URLQueryItem] {
        let dictionary = try self.asDictionary(excluding: keys)
        return dictionary.compactMap { key, value in

            let valueString: String
            if let boolValue = value as? Bool {
                valueString = boolValue ? "true" : "false"
            } else {
                valueString = "\(value)"
            }
            
            return URLQueryItem(name: key, value: valueString)
        }
    }
}
