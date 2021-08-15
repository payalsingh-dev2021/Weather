//
//  LocationWeatherData.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import Foundation

struct LocationWeatherData:Decodable{
    let woeid:Int
    let title:String
    let locationType:String
    let coordinate:String
    let timeZone:String
    let sunrise:String
    let sunset:String
    let weatherDayData:[WeatherDayData]
    
    enum CodingKeys: String, CodingKey {
        case woeid
        case title
        case location_type
        case latt_long
        case timezone_name
        case sun_rise
        case sun_set
        case consolidated_weather
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        woeid = try! container.decode(Int.self, forKey: .woeid)
        title = try! container.decode(String.self, forKey: .title)
        locationType = try! container.decode(String.self, forKey: .location_type)
        coordinate = try! container.decode(String.self, forKey: .latt_long)
        timeZone = try! container.decode(String.self, forKey: .timezone_name)
        sunrise = try! container.decode(String.self, forKey: .sun_rise)
        sunset = try! container.decode(String.self, forKey: .sun_set)
        weatherDayData = try! container.decode([WeatherDayData].self, forKey: .consolidated_weather)
    }
}

