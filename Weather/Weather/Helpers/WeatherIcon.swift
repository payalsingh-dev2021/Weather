//
//  WeatherIcon.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import Foundation

fileprivate struct Configuration {
    static let weatherIconURL = URL(string: "https://www.metaweather.com/static/img/weather/")!
    static let defaultIconFormat:IconFormat = .svg
}

fileprivate enum IconFormat:String {
    case svg
    case ico
    case png
    case png64
}

struct WeatherIcon{
    let weatherCode:String
    var iconUrl:URL{
        guard var components = URLComponents(url: Configuration.weatherIconURL, resolvingAgainstBaseURL: false) else {
            //Error
            fatalError("Error occured while creating Weather Icon URL Request")
        }
        
        let iconFormatString = weatherCode + "." + Configuration.defaultIconFormat.rawValue
        
        switch Configuration.defaultIconFormat {
            case .svg:
                components.path.append(iconFormatString)
            case .ico, .png:
                components.path.append(Configuration.defaultIconFormat.rawValue)
                components.path.append(iconFormatString)
            case .png64:
                components.path.append("png/64")
                components.path.append(iconFormatString)
        }
        
        guard let url = components.url else {
            fatalError("Error occured while creating Weather Icon URL Request")
        }
        
        return url
    }
    
}
