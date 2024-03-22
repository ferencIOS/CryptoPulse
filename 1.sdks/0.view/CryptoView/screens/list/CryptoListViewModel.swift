//
//  CryptoListViewModel.swift
//  CryptoView
//
//  Created by francesco scalise on 19/03/24.
//

import Foundation
import CryptoCore

// MARK: - MVI

struct CryptoListViewState: MVI.State {
    var cryptos: [Crypto] = []
    var today: String = ""
    var title: String = ""
    var isLoading = false
    var error: Error? = nil
    var selectedCrypto: Crypto? = nil
    var toast: (Bool, String?) = (false, nil)
}

enum CryptoListViewIntent: MVI.Intent {
    case fetchTopCryptos
    case fetchTodayDate
    case fetchTitle
    case refreshData
}

enum CryptoListViewEffect: MVI.Effect {
    case navigationToDetails(Crypto)
    case showToast(Int)
    case showError(Error)
}

// MARK: - CryptoListViewModel

final class CryptoListViewModel: ViewModel {
    
    typealias S = CryptoListViewState
    typealias I = CryptoListViewIntent
    typealias E = CryptoListViewEffect
    
    @Published var state = CryptoListViewState()
    
    private let cryptoListService: CryptoListServiceProtocol
    
    init(cryptoListService: CryptoListServiceProtocol = CryptoListService()) {
        self.cryptoListService = cryptoListService
    }
}

// MARK: - MVI Intent

extension CryptoListViewModel {
    
    func dispatch(_ intent: CryptoListViewIntent) {
        switch intent {
        case .fetchTopCryptos:
            fetchTopCryptos()
        case .fetchTodayDate:
            fetchTodayDate()
        case .fetchTitle:
            fetchTitle()
        case .refreshData:
            fetchTopCryptos()
            fetchTodayDate()
            fetchTitle()
        }
    }
    
    private func fetchTopCryptos() {
        state.isLoading = true
        state.error = nil
        state.toast = (false, nil)
        
        Task {
            do {
                let cryptos = try await cryptoListService.fetchTopCryptos()
                DispatchQueue.main.async {
                    self.state.isLoading = false
                    self.state.cryptos = cryptos
                }
            } catch NetworkError.rateLimited(let retryAfter) {
                DispatchQueue.main.async {
                    self.state.isLoading = false
                    // Handle showing toast here
                    self.trigger(.showToast(retryAfter))
                }
            } catch {
                DispatchQueue.main.async {
                    self.state.isLoading = false
                    // Convert other errors to your internal error handling as needed
                    self.trigger(.showError(error))
                }
            }
        }
    }
    
    private func fetchTodayDate() {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        let todayString = formatter.string(from: today)
        
        state.today = todayString
    }
    
    private func fetchTitle() {
        state.title = "Markets"
    }
    
}

// MARK: - MVI Effect

extension CryptoListViewModel {
    
    func trigger(_ effect: CryptoListViewEffect) {
        switch effect {
        case .navigationToDetails(let crypto):
            state.selectedCrypto = crypto
        case .showToast(let retryAfter):
            state.toast = (true, "You've hit the rate limit. Please wait \(retryAfter) seconds before retrying.")
        case .showError(let error):
            state.error = error
        }
    }
    
}
