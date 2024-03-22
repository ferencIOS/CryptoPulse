//
//  Indexable.swift
//  UtilitiesSDK
//
//  Created by francesco scalise on 15/03/24.
//

public protocol Indexable {
    var code: String { get }
    var description: String { get }
}

public extension Indexable where Self: LocalizedError {
    var description: String {
        var message = "[" + code + "]"
        if let errorDescription = errorDescription, !errorDescription.isEmpty {
            message += " " + errorDescription
        }
        return message
    }
}
