//
//  CryptoDetailsViewModel.swift
//  CryptoView
//
//  Created by francesco scalise on 19/03/24.
//

import Foundation
import CryptoCore

// MARK: - MVI

struct CryptoDetailsViewState: MVI.State {
    var details: CryptoDetails? = nil
    var isLoading = false
    var error: Error? = nil
}

enum CryptoDetailsViewIntent: MVI.Intent {
    case fetchCryptoDetails
}

enum CryptoDetailsViewEffect: MVI.Effect {
    case showToast(String)
    case showError(Error)
}

// MARK: - CryptoDetailsViewModel

final class CryptoDetailsViewModel: ViewModel {
    
    typealias S = CryptoDetailsViewState
    typealias I = CryptoDetailsViewIntent
    typealias E = CryptoDetailsViewEffect
    
    @Published var state = CryptoDetailsViewState()
        
    private let crypto: Crypto
    private let cryptoDetailsService: CryptoDetailsServiceProtocol
    
    init(
        crypto: Crypto,
        cryptoDetailsService: CryptoDetailsServiceProtocol = CryptoDetailsService()
    ) {
        self.crypto = crypto
        self.cryptoDetailsService = cryptoDetailsService
    }
}

// MARK: - MVI Intent

extension CryptoDetailsViewModel {
    
    func dispatch(_ intent: CryptoDetailsViewIntent) {
        switch intent {
        case .fetchCryptoDetails:
            fetchCryptoDetails()
        }
    }
    
    private func fetchCryptoDetails() {
        state.isLoading = true
        state.error = nil
        
        Task {
            do {
                let details = try await cryptoDetailsService.fetchCryptoDetails(for: crypto)
                DispatchQueue.main.async {
                    self.state.isLoading = false
                    self.state.details = details
                }
            } catch NetworkError.rateLimited(let retryAfter) {
                DispatchQueue.main.async {
                    self.state.isLoading = false
                    // Handle showing toast here
                    self.trigger(.showToast("You've hit the rate limit. Please wait \(retryAfter) seconds before retrying."))
                }
            } catch {
                DispatchQueue.main.async {
                    self.state.isLoading = false
                    self.trigger(.showError(error))
                }
            }
        }
    }
}

// MARK: - MVI Effect

extension CryptoDetailsViewModel {
    
    func trigger(_ effect: CryptoDetailsViewEffect) {
        switch effect {
        case .showToast(let message):
            state.error = TooManyRequestError.retryAfter(message)
        case .showError(let error):
            state.error = error
        }
    }
    
}

// MARK: - Error

enum TooManyRequestError: Error, LocalizedError {
    case retryAfter(String)
    
    var errorDescription: String? {
        switch self {
        case .retryAfter(let message):
            return message
        }
    }
}
