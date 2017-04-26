//
//  NetworkManager.swift
//  AssignmentTwo
//
//  Created by Partenhauser Andreas on 10.02.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import Foundation

public protocol ResponseConvertible {
    init(responseData: Dictionary<String, Any>)
}

public protocol ResponseCollectionConvertible {
    static func collection(_ responseData: Array<Dictionary<String, Any>>) -> [Self]
}

public protocol URLStringConvertible {
    static var urlRoute: String { get }
}

public enum RestMethod: String {
    case POST
    case GET
}

public protocol ResponseDeserializer {
    associatedtype T: ResponseConvertible, ResponseCollectionConvertible
    var objects: [T]? { get set }
    var error: String? { get set }
    
    static func deserialize(_ responseData: Data?) -> Self
}

open class BaseResponseDeserializer<T: ResponseCollectionConvertible & ResponseConvertible> : ResponseDeserializer {
    open var objects: [T]?
    open var error: String?
    
    public init() {
    }
    
    open class func deserialize(_ responseData: Data?) -> Self {
        fatalError()
    }
}

open class NetworkManager: NSObject {
    open class var shared: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        return Singleton.instance
    }
    
    fileprivate var session: URLSession {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        return urlSession
    }
    
    open var baseRequestUrl: String?
    
    /**
     This method builds the URL and uses the the Dictionary extension to pack and encode the parameters passed.
     With help of the generic Response class the server data is already mapped to a Data object.
     There are multiple points of failure which - for now - only forward an error message.
     On successful Response and Mapping the completion handler is called on the main thread, so the UI can update properly.
     - Parameters:
     - routingType: Defaults to the Type of the generic. Prerequesite is the conformance to `ResponseConvertible` and `URLStringConvertible`
     */
    
    open func requestAll<T: ResponseConvertible & ResponseCollectionConvertible & URLStringConvertible>(_ parameters: Dictionary<String, String> = [:], serializer: BaseResponseDeserializer<T>.Type = BaseResponseDeserializer<T>.self, route: String = T.urlRoute, baseURL: String? = NetworkManager.shared.baseRequestUrl, method: RestMethod = .GET, validate shouldValidate: Bool = true, completion: @escaping (_ response: BaseResponseDeserializer<T>?, _ error: String?) -> Void) {
        guard let url = baseURL else {
            DispatchQueue.main.async(execute: { () -> Void in
                completion(nil, "No baseUrl specified. Please set baseRequestUrl on NetworkManager or pass an url")
            })
            return
        }
        guard let request = parameters.request(forBaseUrlString: url + route, method: method) else {
            DispatchQueue.main.async(execute: { () -> Void in
                completion(nil, "Can not request for host: " + url + " with route: " + route + " and parameter: " + parameters.description)
            })
            return
        }
        session.dataTask(with: request) { (responseData, response, error) -> Void in
            if let err = error {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, err.localizedDescription)
                })
                return
            }
            // Handle HTTP Error Codes here
            if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode != 200 {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                })
                return
            }
            let response = serializer.deserialize(responseData)
            DispatchQueue.main.async(execute: { () -> Void in
                completion(response, response.error)
            })
        }.resume()
    }
}

extension Dictionary {
    var TimeoutInterval: TimeInterval {
        return 15
    }

    /**
     Build a request out of a dictionary that represents all parameters.
     - Parameters:
     - urlString: The full qualified url including the route as String.
     - method: The request method, to specify the HTTP method and decide how to add the parameter
     */
    func request(forBaseUrlString urlString: String, method: RestMethod = .GET, user: String? = nil, password: String? = nil) -> URLRequest? {
        switch method {
        case .GET:
            // Create encoded Parameters
            let simplified = keys.count > 0 ? "?" + self.map { return "\($0)=\($1)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! }.joined(separator: "&") : ""
            guard let url = URL(string: urlString + simplified) else {
                return nil
            }
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeoutInterval)
            request.httpMethod = method.rawValue
            return request
        default:
            return nil
        }
    }
}
