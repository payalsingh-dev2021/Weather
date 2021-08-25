//
//  LocationViewModel.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//

import Foundation
import Combine

class LocationViewModel {
    // MARK:- Combine
    @Published private(set) var querying = false
    
    @Published var query: String = ""
    @Published var coordinate: String = ""

    private var subscriptions: Set<AnyCancellable> = []
    
    var locationsPublisher: AnyPublisher<[Location], Never> {
        locationsSubject.eraseToAnyPublisher()
    }

    private let locationsSubject = CurrentValueSubject<[Location], Never>([])
    
    var locations: [Location] {
        get {
            locationsSubject.value
        }
        set {
            locationsSubject.value = newValue
        }
    }
    
    // MARK:- Initialization
    let locationService:LocationServiceDelegate
    
    init(locationService:LocationServiceDelegate) {
        self.locationService = locationService
        setupBindings()
    }

    private func setupBindings() {
        // Observe Search bar Query
        $query
            .removeDuplicates()
            .debounce(for:0.5, scheduler: RunLoop.main)
//            .throttle(for: 2, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] (query) in
                self?.searchLocations(with: query)
            }.store(in: &subscriptions)
        
        // Observe Location Coordinate
        $coordinate
            .removeDuplicates()
            .sink { [weak self] (coordinate) in
                self?.searchLocationsByCoordinate(with: coordinate)
            }.store(in: &subscriptions)
    }
    
    private func searchLocations(with query: String?) {
        guard let query = query else {
            locations = []
            return
        }

        // Update Helper
        querying = true

        locationService.searchLocations(for:query,
                                        searchType:SearchType.Location(query)){[weak self](result) in
            self?.querying = false
            switch result {
                case .success(let locations):
                    self?.locations = locations
                case .failure(_):
                    self?.locations = []
            }
        }
    }
    
    private func searchLocationsByCoordinate(with coordinate: String?) {
        guard let coordinate = coordinate else {
            locations = []
            return
        }

        // Update Helper
        querying = true

        locationService.searchLocations(for:coordinate,
                                        searchType:SearchType.Coordinate(coordinate)){[weak self](result) in
            self?.querying = false
            switch result {
                case .success(let locations):
                    self?.locations = locations
                case .failure(_):
                    self?.locations = []
            }
        }
    }
    

    
    func viewModel(for index: Int) -> LocationRowViewModel {
        LocationRowViewModel(location:locations[index])
    }
    
    var locationCount:Int{
        return locations.count
    }
    
}
