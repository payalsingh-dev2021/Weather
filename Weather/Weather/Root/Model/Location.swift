//
//  Location.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import Foundation

struct Location:Decodable,Equatable{
    let woeid:Int
    let title:String
    let locationType:String
    let coordinate:String
    let distance:Int?
    
    enum CodingKeys: String, CodingKey {
        case woeid
        case title
        case location_type
        case latt_long
        case distance
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        woeid = try! container.decode(Int.self, forKey: .woeid)
        title = try! container.decode(String.self, forKey: .title)
        locationType = try! container.decode(String.self, forKey: .location_type)
        coordinate = try! container.decode(String.self, forKey: .latt_long)
        distance = try? container.decode(Int.self, forKey: .distance)
    }
    
    
}
