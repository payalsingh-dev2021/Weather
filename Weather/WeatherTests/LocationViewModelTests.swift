//
//  LocationTests.swift
//  WeatherTests
//
//  Created by Payal Singh on 15/08/21.
//

import XCTest
import UIKit
import Combine
@testable import Weather

class LocationTests: XCTestCase {

    var viewModel:LocationViewModel!
    var subscriptions: Set<AnyCancellable> = []

    private class MockLocationService:LocationServiceDelegate {
        func searchLocations(for searchString:String,
                                         searchType:SearchType,
                                         completion:@escaping LocationServiceDelegate.Completion){
            if searchString.isEmpty {
                completion(.failure(.invalidQuery))
            }
            else{
                completion(.success([.testLocation]))
            }
        }
    }
    
//    var mockLocations:[Location] {
//        // Load Stub
//        let data = loadStub(name: "location", extension: "json")
//
//        // Create JSON Decoder
//        let decoder = JSONDecoder()
//
//        // Configure JSON Decoder
//        decoder.dateDecodingStrategy = .secondsSince1970
//
//        // Decode JSON
//        let locationData = try! decoder.decode([Location].self, from: data)
//
//        return locationData
//    }
    
    override func setUpWithError() throws {
        
        // Initialize View Model
        viewModel = LocationViewModel(locationService: MockLocationService())
//        rowViewModel = viewModel.viewModel(for: 2)
        
    }
    
    // MARK: - Tests for Location View Model Publisher - SearchQuery

    func testLocationsPublisherWithValuesQuery() {
        // Define Expectation
        let expectation = self.expectation(description: "Has Locations")

        // Define Expected Values
        let expectedValues: [[Location]] = [
            [],
            [.testLocation]
        ]

        // Subscribe to Locations Publisher
        viewModel.locationsPublisher
            .collect(2)
            .sink { (result) in
                if result == expectedValues {
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)

        // Set Query
        viewModel.query = "San Jose"

        // Wait for Expectations
        wait(for: [expectation], timeout: 1.0)
    }

    func testLocationsPublisherNoValuesQuery() {
        // Define Expectation
        let expectation = self.expectation(description: "No Locations")

        // Define Expected Values
        let expectedValues: [[Location]] = [
            [],
            []
        ]

        // Subscribe to Locations Publisher
        viewModel.locationsPublisher
            .collect(2)
            .sink { (result) in
                if result == expectedValues {
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)

        // Set Query
        viewModel.query = ""

        // Wait for Expectations
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Tests for Location View Model Publisher - Coordinate
    
    func testLocationsPublisherWithValuesCoordinate() {
        // Define Expectation
        let expectation = self.expectation(description: "Has Locations")

        // Define Expected Values
        let expectedValues: [[Location]] = [
            [],
            [.testLocation]
        ]

        // Subscribe to Locations Publisher
        viewModel.locationsPublisher
            .collect(2)
            .sink { (result) in
                if result == expectedValues {
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)

        // Set Query
        viewModel.coordinate = "37.338581,-121.885567"

        // Wait for Expectations
        wait(for: [expectation], timeout: 1.0)
    }

    func testLocationsPublisherNoValuesCoordinate() {
        // Define Expectation
        let expectation = self.expectation(description: "No Locations")

        // Define Expected Values
        let expectedValues: [[Location]] = [
            [],
            []
        ]

        // Subscribe to Locations Publisher
        viewModel.locationsPublisher
            .collect(2)
            .sink { (result) in
                if result == expectedValues {
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)

        // Set Query
        viewModel.coordinate = ""

        // Wait for Expectations
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    // MARK: - Tests for Location Row View Model At Index

    func testLocationRowViewModelValues() {
        // Define Expectation
        let expectation = self.expectation(description: "Location Not Nil")

        // Attach Subscriber
        viewModel.locationsPublisher
            .collect(2)
            .sink { [weak self] _ in
                if self?.viewModel.locationCount == 1,
                   let rowViewModel = self?.viewModel.viewModel(for: 0) {

                    if rowViewModel.locationTitle == Location.testLocation.title &&
                        rowViewModel.locationType == Location.testLocation.locationType &&
                        rowViewModel.locationId == String(Location.testLocation.woeid) {
                        expectation.fulfill()
                    }
                }
            }.store(in: &subscriptions)

        // Set Query
        viewModel.query = "San Jose"

        // Wait for Expectations
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLocationRowViewModelEmpty() {
        // Define Expectation
        let expectation = self.expectation(description: "Location Nil")

        // Attach Subscriber
        viewModel.locationsPublisher
            .collect(2)
            .sink { [weak self] _ in
                if self?.viewModel.locationCount == 0 {
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)

        // Set Query
        viewModel.query = ""

        // Wait for Expectations
        wait(for: [expectation], timeout: 1.0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


}



fileprivate extension Location {
    
    static var testLocation: Location {
        let testLocationString = """
          {
            "title": "San Jose",
            "location_type": "City",
            "woeid": 2488042,
            "latt_long": "37.338581,-121.885567"
          }
        """
        // Create JSON Decoder
        let decoder = JSONDecoder()
        
        // Configure JSON Decoder
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let testLocationData:Location = try! decoder.decode(Location.self,
                                                           from: Data(testLocationString.utf8))
        return testLocationData
    }
    
}
