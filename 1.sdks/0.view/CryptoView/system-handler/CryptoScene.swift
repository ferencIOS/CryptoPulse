//
//  CryptoScene.swift
//  CryptoView
//
//  Created by francesco scalise on 19/03/24.
//

import SwiftUI

public struct CryptoScene: Scene {
    
    public init() {}

    public var body: some Scene {
        WindowGroup {
            CryptoListView(viewModel: CryptoListViewModel())
        }
    }
}
