//
//  LocationRowViewModel.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//

import Foundation


struct LocationRowViewModel {

    let location: Location

    var locationId:String{
        return String(location.woeid)
    }
    
    var locationTitle:String{
        return location.title
    }
    
    var locationType:String{
        return location.locationType
    }
    
}

