//
//  WeatherDayRowViewModel.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//

import Foundation

struct WeatherDayRowViewModel {

    // MARK: - Properties
    private let dateFormatter = DateFormatter()
    let weatherDayData: WeatherDayData
    
    var averageTemperature:String{
        return String(format: "%.0f °C", weatherDayData.currentTemp.rounded())
    }
    
    var minTemperature:String{
        return String(format: "Min : %.0f °C", weatherDayData.minTemp.rounded())
    }
    
    var maxTemperature:String{
        return String(format: "Max : %.0f °C", weatherDayData.maxTemp.rounded())
    }
    
    var temperatureRange:String{
        return String(format: "%.0f °C - %.0f °C", weatherDayData.minTemp.rounded(), weatherDayData.maxTemp.rounded())
    }
    
    var weather:String{
        return weatherDayData.weather
    }
    
    var humidity:String{
        return String(format: "Humidity : %.0f", weatherDayData.humidity) + "%"
    }
    
    var airPressure:String{
        return String(format: "Pressure : %.0f mbar", weatherDayData.airPressure)
    }
    
    var visibility:String{
        return String(format: "Visibility : %.0f miles", weatherDayData.visibility)
    }
    
    var wind:String{
        return String(format: "Wind : %.0f mph %@", weatherDayData.windSpeed, weatherDayData.windDirection)
    }
    
    var day: String {
        let date = getDate(from: weatherDayData.applicableDate)
        return date.getDayOfWeek()
    }

    var date: String {
        let date = getDate(from: weatherDayData.applicableDate)
        return date.getFormattedDate()
    }
    
//    var imageUrl: URL {
//        return WeatherIcon(weatherCode: weatherDayData.weatherCode).iconUrl
//    }
    
    var imageName: String {
        return String(format: "%@.png", weatherDayData.weatherCode)
    }
    

    private func getDate(from string:String) -> Date{
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:string)!
        return date
    }
    
    
}
