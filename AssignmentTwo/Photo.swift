//
//  Photo.swift
//  AssignmentTwo
//
//  Created by Partenhauser Andreas on 10.02.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import Foundation

final class Photo: NSObject, ResponseCollectionConvertible, ResponseConvertible, URLStringConvertible {
    static var urlRoute: String {
        return ""
    }
    
    var identifier: String = ""
    var title: String = ""
    var owner: String = ""
    var secret: String = ""
    var server: String = ""
    
    
    static func collection(_ responseData: Array<Dictionary<String, Any>>) -> [Photo] {
        var photos = Array<Photo>()
        for photoData in responseData {
            photos += [Photo(responseData: photoData)]
        }
        return photos
    }
    
    init(responseData: Dictionary<String, Any>) {
        // TODO mapping
        identifier = responseData["id"] as? String ?? ""
        title = responseData["title"] as? String ?? ""
        owner = responseData["owner"] as? String ?? ""
        secret = responseData["secret"] as? String ?? ""
        server = responseData["server"] as? String ?? ""
    }
}
