//
//  WeatherDayData.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import Foundation

struct WeatherDayData: Decodable {
    
    let applicableDate : String
    let weather : String
    let weatherCode : String
    let windDirection : String
    let windSpeed : Double // mph
    let minTemp : Double // in C
    let maxTemp : Double // in C
    let currentTemp : Double // in C
    let visibility : Double // miles
    let humidity : Double // percentage
    let airPressure : Double // mbar

    
    enum CodingKeys: String, CodingKey {
        case applicable_date
        case weather_state_name
        case weather_state_abbr
        case wind_direction_compass
        case wind_speed
        case min_temp
        case max_temp
        case the_temp
        case visibility
        case humidity
        case air_pressure
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        applicableDate = try! container.decode(String.self, forKey: .applicable_date)        
        weather = try! container.decode(String.self, forKey: .weather_state_name)
        weatherCode = try! container.decode(String.self, forKey: .weather_state_abbr)
        windDirection = try! container.decode(String.self, forKey: .wind_direction_compass)
        windSpeed = try! container.decode(Double.self, forKey: .wind_speed)
        minTemp = try! container.decode(Double.self, forKey: .min_temp)
        maxTemp = try! container.decode(Double.self, forKey: .max_temp)
        currentTemp = try! container.decode(Double.self, forKey: .the_temp)
        visibility = try! container.decode(Double.self, forKey: .visibility)
        humidity = try! container.decode(Double.self, forKey: .humidity)
        airPressure = try! container.decode(Double.self, forKey: .air_pressure)
    }
    
    
}
