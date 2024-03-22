//
//  StringExtension.swift
//  CryptoUtilities
//
//  Created by francesco scalise on 15/03/24.
//

// MARK: Localized

public extension String {
    
    /// Returns the following when key is nil or not found in table:
    ///  - If key is nil and value is nil, returns an empty string.
    ///  - If key is nil and value is non-nil, returns value.
    ///  - If key is not found and value is nil or an empty string, returns key.
    ///  - If key is not found and value is non-nil and not empty, return value.
    var localized: String {
        NSLocalizedString(self, comment:"")
    }
    
    //    func localized(_ arguments: CVarArg...) -> String {
    func localized(_ arguments: [String]) -> String {
        .init(format: self.localized, arguments: arguments)
    }
}
