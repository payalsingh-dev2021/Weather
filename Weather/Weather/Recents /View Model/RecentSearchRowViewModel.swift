//
//  RecentSearchRowViewModel.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//

import Foundation
struct RecentSearchRowViewModel {
    private let recentSearch:RecentSearch
    init(recentSearch:RecentSearch) {
        self.recentSearch = recentSearch
    }
    
    var recentSearchText:String{
        return recentSearch.keyword
    }
    
    var searchTimestamp:String{
        return recentSearch.timestamp
    }
}
