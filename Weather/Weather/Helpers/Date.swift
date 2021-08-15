//
//  Date.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import Foundation
extension Date {
    
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone.current // Local
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func getDayOfWeek() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayOfWeek = formatter.string(from: self).capitalized
        return dayOfWeek
    }
}
