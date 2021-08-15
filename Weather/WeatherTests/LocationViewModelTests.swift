//
//  LocationTests.swift
//  WeatherTests
//
//  Created by Payal Singh on 15/08/21.
//

import XCTest
import UIKit
@testable import Weather

class LocationTests: XCTestCase {

    var viewModel:LocationViewModel!
    var rowViewModel:LocationRowViewModel!
    
    override func setUpWithError() throws {
        // Load Stub
        let data = loadStub(name: "location", extension: "json")
        
        // Create JSON Decoder
        let decoder = JSONDecoder()
        
        // Configure JSON Decoder
        decoder.dateDecodingStrategy = .secondsSince1970
        
        // Decode JSON
        let locationData = try decoder.decode([Location].self, from: data)
        
        // Initialize View Model
        viewModel = LocationViewModel(locations: locationData)
        rowViewModel = viewModel.viewModel(for: 2)
        
    }
    
    func testLocationCount() {
        XCTAssertEqual(viewModel.locationCount, 11)
    }
    
    //TESTING ROW VIEW MODEL AND CONTAINER VIEW MODEL IN SAME FILE DUE TO SMALL NUMBER OF CASES AND TIME CONSTRAINT
    
    func testLocationId(){
        XCTAssertEqual(rowViewModel.locationId, "2488042")
    }
    
    func testLocationTitle(){
        XCTAssertEqual(rowViewModel.locationTitle, "San Jose")
    }
    
    func testLocationType(){
        XCTAssertEqual(rowViewModel.locationType, "City")
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


}
