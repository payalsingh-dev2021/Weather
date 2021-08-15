//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Payal Singh on 13/08/21.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    var viewModel:LocationWeatherDataViewModel!
    var rowViewModel:WeatherDayRowViewModel!
    
    override func setUpWithError() throws {
        // Load Stub
        let data = loadStub(name: "weather", extension: "json")
        
        // Create JSON Decoder
        let decoder = JSONDecoder()
        
        // Configure JSON Decoder
        decoder.dateDecodingStrategy = .secondsSince1970
        
        // Decode JSON
        let locationWeatherData = try decoder.decode(LocationWeatherData.self, from: data)
        
        // Initialize View Model
        viewModel = LocationWeatherDataViewModel(locationWeatherData: locationWeatherData)
        rowViewModel = viewModel.viewModel(for: 0)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testLocationID(){
        XCTAssertEqual(viewModel.locationID, 2487956)
    }
    
    func testLocationTitle(){
        XCTAssertEqual(viewModel.locationTitle, "San Francisco")
    }
    
    func testDaysCount(){
        XCTAssertEqual(viewModel.daysCount, 6)
    }
    
    //TESTING ROW VIEW MODEL AND CONTAINER VIEW MODEL IN SAME FILE DUE TO SMALL NUMBER OF CASES AND TIME CONSTRAINT

    func testAverageTemperature(){
        XCTAssertEqual(rowViewModel.averageTemperature, "22 °C")
    }
    
    func testMinTemperature(){
        XCTAssertEqual(rowViewModel.minTemperature, "Min : 14 °C")
    }
    
    func testMaxTemperature(){
        XCTAssertEqual(rowViewModel.maxTemperature, "Max : 21 °C")
    }
    
    func testTemperatureRange(){
        XCTAssertEqual(rowViewModel.temperatureRange,"14 °C - 21 °C")
    }
    
    func testWeather(){
        XCTAssertEqual(rowViewModel.weather, "Light Cloud")
    }
    
    func testHumidity(){
        XCTAssertEqual(rowViewModel.humidity, "Humidity : 70%")
    }
    
    func testAirpressure(){
        XCTAssertEqual(rowViewModel.airPressure, "Pressure : 1015 mbar")
    }
    
    func testVisibility(){
        XCTAssertEqual(rowViewModel.visibility, "Visibility : 13 miles")
    }
    
    func testWind(){
        XCTAssertEqual(rowViewModel.wind, "Wind : 6 mph WSW")
    }
    
    func testDay(){
        XCTAssertEqual(rowViewModel.day, "Wednesday")
    }
    func testDate(){
        XCTAssertEqual(rowViewModel.date, "11-08-2021")
    }
    func testImageName(){
        XCTAssertEqual(rowViewModel.imageName, "lc.png")
    }
}
