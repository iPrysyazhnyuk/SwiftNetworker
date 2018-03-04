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
    
    /// Make request with JSON Dictionary response.
    ///
    /// - Parameters:
    ///   - onSuccess: Closure for success response
    ///   - onError: Closure for error response
    /// - Returns: NetworkerRequest you can use for example to cancel request
    @discardableResult
    public func requestJSON(
        onSuccess: @escaping (_ json: JSON, _ statusCode: Int) -> (),
        onError: @escaping (Error) -> ()) -> NetworkerRequest? {
        return Networker.requestJSON(url: url,
                                     method: method,
                                     params: params,
                                     encoding: encoding,
                                     headers: headers,
                                     onSuccess: onSuccess,
                                     onError: onError)
    }
    
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
 
    /// Make request with simplified Mappable response
    ///
    /// - Parameters:
    ///   - onSuccess: Closure called when success response received with Mappable object
    ///   - onError: Closure called when error response received
    /// - Returns: NetworkerRequest you can use for example to cancel request
    @discardableResult
    public func requestMappable<T: Mappable>(onSuccess: @escaping (T) -> (),
                                             onError: ((Error) -> ())? = nil) -> NetworkerRequest? {
        return Networker.requestMappable(url: url,
                                         method: method,
                                         params: params,
                                         encoding: encoding,
                                         headers: headers,
                                         onSuccess: onSuccess,
                                         onError: onError)
    }
    
    /// Make request without response handling
    ///
    /// - Returns: NetworkerRequest you can use for example to cancel request
    @discardableResult
    public func request(onError: ((Error) -> ())? = nil) -> NetworkerRequest? {
        return Networker.request(url: url,
                                 method: method,
                                 params: params,
                                 encoding: encoding,
                                 headers: headers,
                                 onError: onError)
    }
}
