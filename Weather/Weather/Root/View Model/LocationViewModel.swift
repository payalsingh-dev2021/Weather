//
//  LocationViewModel.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//

import Foundation

struct LocationViewModel {

    let locations: [Location]

    func viewModel(for index: Int) -> LocationRowViewModel {
        LocationRowViewModel(location:locations[index])
    }
    
    var locationCount:Int{
        return locations.count
    }
    
}
