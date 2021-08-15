//
//  WeatherServiceRequest.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import Foundation

enum SearchType {
    case Coordinate(String)
    case Location(String)
    case EarthID(String)
}

struct WeatherServiceRequest {
    
    // MARK: - Properties
    private let baseUrl = URL(string: "https://www.metaweather.com/api/location/")!
    private let baseSearchUrl = URL(string: "https://www.metaweather.com/api/location/search/")!
    
    // MARK: -
    var searchType:SearchType
    
    // MARK: - Public API
    var url: URL {
        var weatherBaseURL:URL = baseSearchUrl
        if case SearchType.EarthID = searchType{
            weatherBaseURL = baseUrl
        }
        
        guard var components = URLComponents(url: weatherBaseURL, resolvingAgainstBaseURL: false) else {
            //Error
            fatalError("Error occured while creating Weather Service Request")
        }
        
        switch searchType {
            case .Coordinate(let coordinate):
                components.queryItems = [URLQueryItem(name: "lattlong", value: "\(coordinate)")]
            case .Location(let query):
                components.queryItems = [URLQueryItem(name: "query", value: "\(query)")]
            case .EarthID(let woeid):
                components.path.append(woeid)
        }
        
        guard let url = components.url else {
            fatalError("Error occured while creating Weather Service Request")
        }
        
        return url
    }

 
}

