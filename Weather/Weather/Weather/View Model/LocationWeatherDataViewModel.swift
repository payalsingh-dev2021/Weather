//
//  LocationWeatherDataViewModel.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//

import Foundation
struct LocationWeatherDataViewModel{
    private let locationWeatherData: LocationWeatherData
    private let dateFormatter = DateFormatter()

    init(locationWeatherData:LocationWeatherData) {
        self.locationWeatherData = locationWeatherData
    }
    
    var locationID:Int {
        return locationWeatherData.woeid
    }
    
    var locationTitle:String {
        return locationWeatherData.title
    }
    
//    func currentDayViewModel() -> WeatherDayRowViewModel?{
//        if locationWeatherData.weatherDayData.count > 0{
//            return WeatherDayRowViewModel(weatherDayData: locationWeatherData.weatherDayData[0])
//        }
//        return nil
//    }
    
    func viewModel(for index: Int) -> WeatherDayRowViewModel {
        WeatherDayRowViewModel(weatherDayData: locationWeatherData.weatherDayData[index])
    }
    
    var daysCount:Int{
        return locationWeatherData.weatherDayData.count
    }
    
    private func getTime(from string:String) -> Date{
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from:string)!
        return date
    }

}

