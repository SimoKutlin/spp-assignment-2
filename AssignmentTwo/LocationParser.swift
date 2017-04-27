//
//  LocationParser.swift
//  AssignmentTwo
//
//  Created by admin on 27.04.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import Foundation

class LocationParser<T>: JSONParser where T: ResponseCollectionConvertible & ResponseConvertible {
    // Since we have an Array response we need to do transformation to confirm to our needs.
    static func parse(_ responseData: Data) throws -> Dictionary<String, Any>? {
        guard let jsonApiResult = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)  as? Dictionary<String, Any> else {
            return nil
        }
        return jsonApiResult
    }
    
    static func map(_ rootObject: Dictionary<String, Any>) -> (result: Array<T>?, userInfo: Dictionary<String, Any>, error: String?) {
        guard let photos = rootObject["photos"] as? Dictionary<String, Any>, let photoCollection = photos["photo"] as? Array<Dictionary<String, Any>> else {
            return (nil, [:], nil)
        }
        let objects = T.collection(photoCollection)
        
        return (objects, [:], nil)
    }
}
