//
//  NetworkerRouter.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import Alamofire
import ObjectMapper

public protocol NetworkerRouter {
    var baseUrl: String { get }
    var endpoint: String { get }
    var url: String { get }
    var method: HTTPMethod { get }
    var params: Parameters? { get }
    var encoding: ParameterEncoding? { get }
    var headers: [String: String]? { get }
}

public extension NetworkerRouter {
    var url: String { return baseUrl + endpoint }
    var params: Parameters? { return nil }
    var encoding: ParameterEncoding? { return nil }
    var headers: [String: String]? { return nil }
    
    /// Make request with JSON Dictionary response
    ///
    /// - Parameters:
    ///   - callback: Closure with JSON result
    /// - Returns: NetworkerRequest you can use for example to cancel request
    @discardableResult
    public func requestJSON(callback: @escaping (NetworkerJSONResult) -> ()) -> NetworkerRequest? {
        return Networker.requestJSON(url: url,
                              method: method,
                              params: params,
                              encoding: encoding,
                              headers: headers,
                              callback: callback)
    }
    
    /// Make request with Mappable response
    ///
    /// - Parameters:
    ///   - callback: Closure with Mappable result
    /// - Returns: NetworkerRequest you can use for example to cancel request
    @discardableResult
    public func requestMappable<T>(callback: @escaping (NetworkerMappableResult<T>) -> ()) -> NetworkerRequest? {
        return Networker.requestMappable(url: url,
                                  method: method,
                                  params: params,
                                  encoding: encoding,
                                  headers: headers,
                                  callback: callback)
    }
}
