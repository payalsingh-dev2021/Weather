//
//  RecentSearchViewModel.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//

import Foundation
struct RecentSearchViewModel{
    private let recentSearches:[RecentSearch]
    init(recentSearches:[RecentSearch]){
        self.recentSearches = recentSearches
    }
    
    func viewModel(for index: Int) -> RecentSearchRowViewModel {
        RecentSearchRowViewModel(recentSearch:recentSearches[index])
    }
    
    var searchesCount:Int{
        return recentSearches.count
    }
    
}

