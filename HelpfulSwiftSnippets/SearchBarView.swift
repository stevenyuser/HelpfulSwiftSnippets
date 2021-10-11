//
//  SearchBarView.swift
//  HelpfulSwiftSnippets
//
//  Created by Steven Yu on 10/10/21.
//

import SwiftUI

// A search bar component that binds to a searchText
/*
 You can use this search bar with Combine to make a powerful searcher.
 Basically, you make the search field text a publisher (since it publishes values) and subscribe to it, then filter on your data whenever the search field changes
 
 Example Usage:
 // viewmodel:
 @Published var searchText: String = ""
 private let dataService = CoinDataService()
 @Published var allCoins: [CoinModel] = []
 
 func addSubscribers() {
     // updates allCoins
     $searchText
         .combineLatest(dataService.$allCoins)
         .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
         .map(filterCoins)
         .sink { [weak self] (returnedCoins) in
             self?.allCoins = returnedCoins
         }
         .store(in: &cancellables)
 }
 
 private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
     guard !text.isEmpty else {
         return coins
     }
     let lowercasedText = text.lowercased()
     return coins.filter { (coin) -> Bool in
         return coin.name.lowercased().contains(lowercasedText) ||
             coin.symbol.lowercased().contains(lowercasedText) ||
             coin.id.lowercased().contains(lowercasedText)
     }
 }

 // view:
 @EnvironmentObject private var vm: HomeViewModel
 SearchBarView(searchText: $vm.searchText)
 */

struct SearchBarView: View {
    
    @State var searchText: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.primary)
            
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Color.primary)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.primary)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                        }
                    
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.white) // make this dynamic for light/dark mode
                .shadow(
                    color: Color.primary.opacity(0.15),
                    radius: 10, x: 0.0, y: 0.0)
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView()
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            SearchBarView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
        }
    }
}
