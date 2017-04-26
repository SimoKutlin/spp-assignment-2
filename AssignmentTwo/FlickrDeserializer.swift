//
//  FlickrDeserializer.swift
//  AssignmentTwo
//
//  Created by Partenhauser Andreas on 10.02.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import Foundation

open class FlickrDeserializer<T>: BaseResponseDeserializer<T> where T: ResponseConvertible & ResponseCollectionConvertible {
    open override class func deserialize(_ responseData: Data?) -> FlickrDeserializer<T> {
        let response = FlickrDeserializer<T>()
        guard let data = responseData else {
            response.error = "No Data returned - Response data is nil."
            
            return response
        }
        do {
            guard let mapped = try FlickrParser<T>.parse(data) else {
                response.error = "Not able to parse data to JSON - NSData: \(data)"
                return response
            }
            let results = FlickrParser<T>.map(mapped)
            response.objects = results.result
            return response
        } catch let caughtError as NSError {
            response.error = caughtError.localizedDescription
            
            return response
        } catch {
            response.error = "Some error occoured while parsing the response to JSON."
            
            return response
        }
    }
}
