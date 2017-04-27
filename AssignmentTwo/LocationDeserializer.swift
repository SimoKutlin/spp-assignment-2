//
//  LocationDeserializer.swift
//  AssignmentTwo
//
//  Created by admin on 27.04.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import Foundation

open class LocationDeserializer<T>: BaseResponseDeserializer<T> where T: ResponseConvertible & ResponseCollectionConvertible {
    open override class func deserialize(_ responseData: Data?) -> LocationDeserializer<T> {
        let response = LocationDeserializer<T>()
        guard let data = responseData else {
            response.error = "No Data returned - Response data is nil."
            
            return response
        }
        do {
            guard let parsed = try FlickrParser<T>.parse(data) else {
                response.error = "Not able to parse data to JSON - NSData: \(data)"
                return response
            }
            
            response.objects = [T]()
            response.objects?.append(T(responseData: parsed))
            
            //response.objects = results.result
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
