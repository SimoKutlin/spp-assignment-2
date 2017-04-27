//
//  Location.swift
//  AssignmentTwo
//
//  Created by admin on 27.04.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import Foundation

final class Location: NSObject, ResponseCollectionConvertible, ResponseConvertible, URLStringConvertible {
    // Actually not needed, but network manager does so there ya go
    static var urlRoute: String {
        return ""
    }
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var accuracy: Int = 0
    
    static func collection(_ responseData: Array<Dictionary<String, Any>>) -> [Location] {
        print("locating \(responseData)")
        var locations = Array<Location>()
        for locationData in responseData {
            locations += [Location(responseData: locationData)]
        }
        return locations
    }
    
    init(responseData: Dictionary<String, Any>) {
        if let photoData = responseData["photo"] as! Dictionary<String, Any>? {
            if let locationData = photoData["location"] as! Dictionary<String, Any>? {
                latitude = Double((locationData["latitude"] as? String)!)!
                longitude = Double((locationData["longitude"] as? String)!)!
                accuracy = Int((locationData["accuracy"] as? String)!)!
            }
        }
        
    }
}
