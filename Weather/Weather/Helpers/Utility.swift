//
//  Utility.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//

import Foundation

struct Utility{
    static func getCurrentTimeStamp()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d YYYY, hh:mm a"
        let date = dateFormatter.string(from: Date())
        return date
    }
}

