//
//  CryptoDetailsView.swift
//  CryptoView
//
//  Created by francesco scalise on 19/03/24.
//

import SwiftUI
import Charts
import CryptoCore

struct CryptoDetailsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CryptoDetailsViewModel
    
    init(viewModel: CryptoDetailsViewModel) {
        self.viewModel = viewModel
        
        viewModel.dispatch(.fetchCryptoDetails)
    }
    
    var body: some View {
        VStack {
            if let details = viewModel.state.details {
                contentView(for: details)
            } else if viewModel.state.isLoading {
                progressView()
            } else if let error = viewModel.state.error {
                errorView(error: error)
            } else {
                fatalError("invalid state")
            }
        }
    }
}

// MARK: - ViewBuilder

extension CryptoDetailsView {
    
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
    private func contentView(for details: CryptoDetails) -> some View {
        ScrollView {
            
            closeButton()
            
            VStack(alignment: .center) {
                
                imageView(for: details)
                
                descriptionView(for: details)
                
                homepageView(for: details)
                
                chartView(prices: details.historicalPrices)
            }
        }
        .background(Color.black.opacity(0.9))
    }
    
    @ViewBuilder
    private func closeButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .padding(12)
//                    .background(Circle().fill(Color.gray.opacity(0.6)))
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
    }
    
    @ViewBuilder
    private func imageView(for details: CryptoDetails) -> some View {
        AsyncImage(url: details.imageURL) { phase in
            switch phase {
            case .empty:
                Image(systemName: "photo")
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .frame(height: 200)
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func descriptionView(for details: CryptoDetails) -> some View {
        VStack(alignment: .center) {
            Text("\(details.name) - \(details.symbol)")
            //                            .padding()
                .foregroundColor(Color.white)
            
            HStack {
                Text("\(details.currentPrice) \(details.currency)")
                //                            .padding()
                    .foregroundColor(Color.white)
                
                Text(formatPriceChange(details.priceChangePercentage24H))
                    .foregroundColor(details.priceChangePercentage24H.contains("-") ? Color.red : Color.green)
                    .font(.headline)
                    .padding(3)
                    .background(details.priceChangePercentage24H.contains("-") ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                    .cornerRadius(7)
            }
            
            Divider()
                .overlay(Color.white.opacity(0.2))
            
            ExpandableView(fullText: details.description)
                .padding()
        }
    }
    
    @ViewBuilder
    private func homepageView(for details: CryptoDetails) -> some View {
        if let homepageURL = details.homepageURL {
            
            Divider()
                .overlay(Color.white.opacity(0.2))
            Link("\(homepageURL)", destination: homepageURL)
                .padding()
            Divider()
                .overlay(Color.white.opacity(0.2))
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    private func chartView(prices: [Double]) -> some View {
        if prices.isEmpty {
            Text("No data available")
                .foregroundColor(.gray)
                .padding()
        } else {
            let overallChangeColor = overallChangeIsPositive(viewModel.state.details?.priceChangePercentage24H ?? "0") ? Color.green : Color.red
            
            let daysLabels = calculateDaysLabels(count: prices.count)
            
            let chartData = zip(daysLabels, prices).map(ChartData.init)
            
            Chart(chartData, id: \.dayLabel) { data in
                LineMark(
                    x: .value("Day", data.dayLabel),
                    y: .value("Price", data.price)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(overallChangeColor)
                
                AreaMark(
                    x: .value("Day", data.dayLabel),
                    y: .value("Price", data.price)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [overallChangeColor.opacity(0.6), overallChangeColor.opacity(0)]), startPoint: .top, endPoint: .bottom))
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .bottom) {
                    AxisGridLine().foregroundStyle(Color.white.opacity(0.2))
                    AxisTick()
                    AxisValueLabel().foregroundStyle(Color.white)
                }
            }
            .chartYAxis {
                AxisMarks(preset: .aligned, position: .trailing) {
                    AxisGridLine().foregroundStyle(Color.white.opacity(0.2))
                    AxisTick()
                    AxisValueLabel().foregroundStyle(Color.white)
                }
            }
            .frame(height: 300)
            .padding()
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
                    closeButton()
                    
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
        .background(Color.black.opacity(0.9))
    }
}

// MARK: - Helper

extension CryptoDetailsView {
    
    private func overallChangeIsPositive(_ change: String) -> Bool {
        guard let value = Double(change.trimmingCharacters(in: CharacterSet(charactersIn: "%"))) else { return false }
        return value > 0
    }
    
    private func calculateDaysLabels(count: Int) -> [String] {
        let calendar = Calendar.current
        let today = Date()
        var labels = (0..<count).reversed().map { offset in
            guard let dayDate = calendar.date(byAdding: .day, value: -offset, to: today) else { return "" }
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EE" // "EE" per il nome breve del giorno
            return dayFormatter.string(from: dayDate)
        }

        if !labels.isEmpty {
            labels[labels.count - 1] = "Now"
        }

        return labels
    }
    
    private func formatPriceChange(_ change: String) -> String {
        guard let value = Double(change.trimmingCharacters(in: CharacterSet(charactersIn: "%"))) else { return change }
        return value > 0 ? "+\(change)" : change
    }
    
}

// MARK: - Preview

#if DEBUG
#Preview {
    let crypto = Crypto(id: "bitcoin", currency: "EUR", name: "Bitcoin", symbol: "BTC", imageUrl: URL(string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png")!, currentPrice: "€30,000", priceChangePercentage24H: "-500.32%")
    let service = MockCryptoDetailsService()
    //        let service = CryptoDetailsService()
    let listViewModel = CryptoListViewModel()
    let viewModel = CryptoDetailsViewModel(crypto: crypto, cryptoDetailsService: service)
    return CryptoDetailsView(viewModel: viewModel)
        .previewLayout(.sizeThatFits)
}
#endif

// MARK: - Helper

struct ChartData {
    var dayLabel: String
    var price: Double
}
