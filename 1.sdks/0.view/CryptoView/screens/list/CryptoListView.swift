//
//  CryptoListView.swift
//  CryptoView
//
//  Created by francesco scalise on 19/03/24.
//

import SwiftUI
import CryptoCore

// MARK: - CryptoListView

struct CryptoListView: View {
    
    @ObservedObject var viewModel: CryptoListViewModel
    
    init(viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        
        viewModel.dispatch(.fetchTitle)
        viewModel.dispatch(.fetchTodayDate)
        viewModel.dispatch(.fetchTopCryptos)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Color.black
                if let error = viewModel.state.error {
                    errorView(error: error)
                } else if viewModel.state.isLoading {
                    progressView()
                } else {
                    contentView()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .sheet(item: $viewModel.state.selectedCrypto) { crypto in
                CryptoDetailsView(viewModel: .init(crypto: crypto))
            }
        }
        .background(Color.black)
        .overlay(toastView, alignment: .bottom)
    }
    
}

// MARK: - ViewBuilder

extension CryptoListView {
    
    @ViewBuilder
    private func progressView() -> some View {
        ZStack {
            Color.black.opacity(0.9)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2)
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        VStack(alignment: .leading) {
            
            Spacer(minLength: 50)
            
            marketsHedgingView()
            todayDateView()
            
            listView()
            //Spacer()
        }
    }
    
    @ViewBuilder
    private func errorView(error: Error) -> some View {
        //#if DEBUG
        //        let description = String(describing: error)
        //#else
                let description = error.localizedDescription
        //#endif
        
        ScrollView {
            ZStack {
                // Reserve space matching the scroll view's frame
                Spacer().containerRelativeFrame([.horizontal, .vertical])
                
                // Form content
                VStack {
                    ContentUnavailableView(
                        "Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text(description)
                    )
                    .foregroundStyle(Color.white)
                }
                .padding()
            }
        }
        .refreshable {
            viewModel.dispatch(.refreshData)
        }
    }
    
    @ViewBuilder
    private func marketsHedgingView() -> some View {
        Text(viewModel.state.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
    }
    
    @ViewBuilder
    private func todayDateView() -> some View {
        Text(viewModel.state.today)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
    }
    
    @ViewBuilder
    private func listView() -> some View {
        VStack {
            List {
                ForEach(viewModel.state.cryptos, id: \.id) { crypto in
                    Button(action: {
                        viewModel.trigger(.navigationToDetails(crypto))
                    }) {
                        CryptoCellView(crypto: crypto)
                    }
                }
                // .listRowSeparator(.hidden)
                .listRowSeparatorTint(Color.gray)
                .listRowBackground(Color.clear)
            }
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
            .listStyle(PlainListStyle())
            .refreshable {
                viewModel.dispatch(.refreshData)
            }
        }
        .background(Color.black)
    }
    
    @ViewBuilder
    private var toastView: some View {
        Group {
            if viewModel.state.toast.0 {
                Text(viewModel.state.toast.1!)
                    .padding()
                    .background(Color.gray.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            viewModel.state.toast = (false, nil)
                        }
                    }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    let service = MockCryptoListService()
    // let service = CryptoListService()
    let viewModel = CryptoListViewModel(cryptoListService: service)
    return CryptoListView(viewModel: viewModel)
        .previewLayout(.sizeThatFits)
}
#endif

// MARK: - CryptoCellView

struct CryptoCellView: View {
    var crypto: Crypto
    
    private let priceChangeWidth: CGFloat = 100
    
    var body: some View {
        HStack {
            imageView()
            
            descriptionView()
            
            Spacer()
            
            priceView()
        }
        .padding()
        .background(Color.black)
    }
}

// MARK: - ViewBuilder

extension CryptoCellView {
    
    @ViewBuilder
    private func imageView() -> some View {
        AsyncImage(url: crypto.imageUrl) { phase in
            switch phase {
            case .empty:
                Image(systemName: "photo")
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            case .failure(_):
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    private func descriptionView() -> some View {
        VStack(alignment: .leading) {
            Text(crypto.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            Text(crypto.symbol)
                .foregroundColor(Color.gray)
        }
    }
    
    @ViewBuilder
    private func priceView() -> some View {
        VStack(alignment: .trailing) {
            Text(crypto.currentPrice)
                .foregroundColor(Color.white)
            Text(processPriceChange(crypto.priceChangePercentage24H))
                .frame(width: priceChangeWidth, alignment: .trailing)
                .foregroundColor(crypto.priceChangePercentage24H.contains("-") ? Color.red : Color.green)
                .font(.headline)
                .padding(3)
                .background(crypto.priceChangePercentage24H.contains("-") ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                .cornerRadius(7)
        }
    }
}

// MARK: - Helper

extension CryptoCellView {
    
    private func processPriceChange(_ change: String) -> String {
        if change.contains("-") {
            return change // Already has a "-" sign
        } else {
            return "+\(change)" // Add the "+" sign for positive changes
        }
    }
    
}

// MARK: - Preview

#if DEBUG
#Preview {
    return CryptoCellView(crypto: Crypto(id: "bitcoin", currency: "EUR", name: "Bitcoin", symbol: "BTC", imageUrl: URL(string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png")!, currentPrice: "€30,000", priceChangePercentage24H: "-5000.32%"))
    //            .previewLayout(.sizeThatFits)
}
#endif
