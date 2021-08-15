//
//  RecentSearch+CoreDataProperties.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//
//

import Foundation
import CoreData


extension RecentSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearch> {
        return NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
    }

    @NSManaged public var keyword: String
    @NSManaged public var timestamp: String

}

extension RecentSearch : Identifiable {

}
