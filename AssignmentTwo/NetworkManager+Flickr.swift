//
//  NetworkManager+Flickr.swift
//  AssignmentTwo
//
//  Created by Partenhauser Andreas on 10.02.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import Foundation

struct ParameterName {
    static let ApiKey = "api_key"
    static let Method = "method"
    static let Text = "text"
    static let Format = "format"
    static let PhotoId = "photo_id"
    static let NoJsonCallback = "nojsoncallback"
}

struct ParameterKey {
    static let FlickrAPIKey = "fd2b03f1a74de7a45ebd5c1d54bc2789"
    static let FlickrSecretKey = "c63b8995ba8f0380"
    
    static let FormatNameJson = "json"
    static let NoJsonCallBackValue = "1"
}

struct Methods {
    static let PhotoSearchMethod = "flickr.photos.search"
    static let PhotoLocationMethod = "flickr.photos.geo.getLocation"
    static let PhotoInfoMethod = "flickr.photos.getInfo"
}

extension NetworkManager {
    var baseParameter: Dictionary<String, String> {
        return [ParameterName.ApiKey: ParameterKey.FlickrAPIKey,
                ParameterName.Format: ParameterKey.FormatNameJson,
                ParameterName.NoJsonCallback: ParameterKey.NoJsonCallBackValue]
    }
    
    typealias PhotoRequestCompletion = (_ response: BaseResponseDeserializer<Photo>?, _ error: String?) -> Void
    
    func requestPhotos(with string: String, completion: @escaping PhotoRequestCompletion) {
        var parameter = baseParameter
        parameter[ParameterName.Text] = string
        parameter[ParameterName.Method] = Methods.PhotoSearchMethod
        
        requestAll(parameter, serializer: FlickrDeserializer<Photo>.self, completion: completion)
    }
    
    typealias LocationRequestCompletion = (_ response: BaseResponseDeserializer<Location>?, _ error: String?) -> Void
    
    func requestLocation(for id: String, completion: @escaping LocationRequestCompletion) {
        var parameter = baseParameter
        parameter[ParameterName.PhotoId] = id
        parameter[ParameterName.Method] = Methods.PhotoLocationMethod
        
        requestAll(parameter, serializer: LocationDeserializer<Location>.self, completion: completion)
    }
}
