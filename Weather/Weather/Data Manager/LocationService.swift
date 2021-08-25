//
//  LocationService.swift
//  Weather
//
//  Created by Payal Singh on 25/08/21.
//

import Foundation
protocol LocationServiceDelegate{
    
    typealias Completion = (Result<[Location], LocationServiceError>) -> Void
    
    func searchLocations(for searchString:String,
                                     searchType:SearchType,
                                     completion:@escaping Completion)
}

enum LocationServiceError: Error {
    case invalidQuery
    case requestFailed
}

class LocationService:LocationServiceDelegate{
    
    static let dataManager = DataManager()

    func searchLocations(for searchString:String,
                                     searchType:SearchType,
                                     completion:@escaping Completion){
        guard !searchString.isEmpty else {
            completion(.failure(.invalidQuery))
            return
        }
        print(searchString, "searching#")
        LocationService.dataManager.fetchWeatherData(by: searchType, responseType: [Location].self){(result) in
            switch result {
                case .success(let locationData):
                    completion(.success(locationData))
                case .failure:
                    completion(.failure(.requestFailed))
            }
        }
    }
}
